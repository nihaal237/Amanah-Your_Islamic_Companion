from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework_simplejwt.tokens import RefreshToken
import logging

from .models import AmanahUser
from .serializers import (
    RegisterSerializer,
    LoginSerializer,
    UserProfileSerializer,
    ChangePasswordSerializer,
)


def get_tokens_for_user(user):
    """Generate JWT access + refresh tokens for a user."""
    refresh = RefreshToken.for_user(user)
    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }
logger = logging.getLogger(__name__)

class RegisterView(APIView):
    """
    POST /api/auth/register/
    FR1, FR2: Register new user with NADRA ID and age verification.
    """
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = RegisterSerializer(data=request.data)
        
        # 1. Log incoming data to console for debugging
        print(f"Incoming Registration Data: {request.data}")

        try:
            if serializer.is_valid():
                user = serializer.save()
                tokens = get_tokens_for_user(user)
                return Response({
                    'message': 'Account created successfully.',
                    'user': UserProfileSerializer(user).data,
                    'tokens': tokens,
                }, status=status.HTTP_201_CREATED)
            
            # 2. Handle Validation Errors (e.g., NADRA ID already exists, missing fields)
            print(serializer.errors)
            return Response({
                'error': 'Validation Failed',
                'details': serializer.errors
            }, status=status.HTTP_400_BAD_REQUEST)

        except Exception as e:
            # 3. Log the specific exception to the console
            print(f"CRITICAL ERROR during registration: {str(e)}")
            logger.error(f"Registration Error: {e}", exc_info=True)

            # 4. Return a readable error to the frontend
            return Response({
                'error': 'Internal Server Error',
                'message': 'An unexpected error occurred during registration. Please try again later.'
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
class LoginView(APIView):
    """
    POST /api/auth/login/
    FR1: Login with email + password, returns JWT tokens.
    """
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.validated_data['user']
            tokens = get_tokens_for_user(user)
            return Response({
                'message': 'Login successful.',
                'user': UserProfileSerializer(user).data,
                'tokens': tokens,
            }, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class LogoutView(APIView):
    """
    POST /api/auth/logout/
    Blacklists the refresh token.
    """
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            refresh_token = request.data.get('refresh')
            token = RefreshToken(refresh_token)
            token.blacklist()
            return Response({'message': 'Logged out successfully.'}, status=status.HTTP_200_OK)
        except Exception:
            return Response({'error': 'Invalid token.'}, status=status.HTTP_400_BAD_REQUEST)


class ProfileView(APIView):
    """
    GET   /api/auth/profile/  — view profile (FR4)
    PATCH /api/auth/profile/  — update profile (FR4)
    """
    permission_classes = [IsAuthenticated]

    def get(self, request):
        serializer = UserProfileSerializer(request.user)
        return Response(serializer.data)

    def patch(self, request):
        serializer = UserProfileSerializer(
            request.user, data=request.data, partial=True
        )
        if serializer.is_valid():
            serializer.save()
            return Response({
                'message': 'Profile updated successfully.',
                'user': serializer.data,
            })
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class ChangePasswordView(APIView):
    """
    POST /api/auth/change-password/
    FR3: Change password (requires old password).
    """
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = ChangePasswordSerializer(data=request.data)
        if serializer.is_valid():
            user = request.user
            if not user.check_password(serializer.validated_data['old_password']):
                return Response(
                    {'old_password': 'Incorrect current password.'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            user.set_password(serializer.validated_data['new_password'])
            user.save()
            return Response({'message': 'Password changed successfully.'})
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)