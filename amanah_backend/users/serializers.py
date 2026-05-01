from rest_framework import serializers
from django.contrib.auth import authenticate
from .models import AmanahUser


class RegisterSerializer(serializers.ModelSerializer):
    """
    FR1: User registration with NADRA age check (>=12).
    FR2: NADRA ID required at signup.
    """
    password = serializers.CharField(write_only=True, min_length=8)
    password_confirm = serializers.CharField(write_only=True)

    class Meta:
        model = AmanahUser
        fields = [
            'email', 'username', 'first_name', 'last_name',
            'password', 'password_confirm',
            'gender', 'date_of_birth', 'city', 'country',
            'nadra_id',
        ]
        extra_kwargs = {
            'first_name': {'required': True},
            'last_name': {'required': True},
            'nadra_id': {'required': True},
            'date_of_birth': {'required': True},
        }

    def validate(self, data):
        if data['password'] != data['password_confirm']:
            raise serializers.ValidationError({'password_confirm': 'Passwords do not match.'})
        return data

    def validate_date_of_birth(self, value):
        from datetime import date
        today = date.today()
        age = today.year - value.year - ((today.month, today.day) < (value.month, value.day))
        if age < 12:
            raise serializers.ValidationError('User must be at least 12 years old (FR2).')
        return value

    def validate_nadra_id(self, value):
        cleaned = value.replace('-', '')
        if not cleaned.isdigit() or len(cleaned) != 13:
            raise serializers.ValidationError('NADRA ID must be a 13-digit CNIC number.')
        return cleaned

    def create(self, validated_data):
        validated_data.pop('password_confirm')
        password = validated_data.pop('password')
        user = AmanahUser(**validated_data)
        user.set_password(password)
        user.save()
        return user


class LoginSerializer(serializers.Serializer):
    """FR1: Login with email + password."""
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

    def validate(self, data):
        user = authenticate(username=data['email'], password=data['password'])
        if not user:
            raise serializers.ValidationError('Invalid email or password.')
        if not user.is_active:
            raise serializers.ValidationError('Account is disabled.')
        data['user'] = user
        return data


class UserProfileSerializer(serializers.ModelSerializer):
    """FR4: View and update user profile."""
    full_name = serializers.ReadOnlyField()
    age = serializers.ReadOnlyField()

    class Meta:
        model = AmanahUser
        fields = [
            'id', 'email', 'username', 'first_name', 'last_name', 'full_name',
            'gender', 'date_of_birth', 'age', 'city', 'country',
            'is_user', 'is_scholar', 'is_scholar_verified',
            'is_nadra_verified', 'amanah_score',
            'scholar_bio', 'scholar_specialization',
            'created_at', 'updated_at',
        ]
        read_only_fields = [
            'id', 'email', 'is_user', 'is_scholar', 'is_scholar_verified',
            'is_nadra_verified', 'amanah_score', 'created_at', 'updated_at',
        ]


class ChangePasswordSerializer(serializers.Serializer):
    """FR3: Change password."""
    old_password = serializers.CharField(write_only=True)
    new_password = serializers.CharField(write_only=True, min_length=8)
    new_password_confirm = serializers.CharField(write_only=True)

    def validate(self, data):
        if data['new_password'] != data['new_password_confirm']:
            raise serializers.ValidationError({'new_password_confirm': 'Passwords do not match.'})
        return data