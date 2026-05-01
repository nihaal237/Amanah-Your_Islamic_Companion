from django.contrib.auth.models import AbstractUser
from django.db import models


class AmanahUser(AbstractUser):
    """
    Custom user model for Amanah.
    Extends AbstractUser with role flags and Islamic app-specific fields.
    FR1-FR5: User management
    """

    # Role flags
    is_user = models.BooleanField(default=True)       # Regular user
    is_scholar = models.BooleanField(default=False)   # Verified Islamic scholar
    # is_staff (Django default) = Admin panel access

    # Profile fields (FR4)
    gender = models.CharField(
        max_length=10,
        choices=[('male', 'Male'), ('female', 'Female'), ('prefer_not', 'Prefer not to say')],
        blank=True,
        null=True,
    )
    date_of_birth = models.DateField(blank=True, null=True)
    city = models.CharField(max_length=100, blank=True, null=True)
    country = models.CharField(max_length=100, blank=True, null=True)

    # NADRA verification fields (FR2)
    nadra_id = models.CharField(max_length=15, blank=True, null=True, unique=True)
    is_nadra_verified = models.BooleanField(default=False)

    # Scholar-specific fields (FR22-25)
    scholar_bio = models.TextField(blank=True, null=True)
    scholar_specialization = models.CharField(max_length=200, blank=True, null=True)
    is_scholar_verified = models.BooleanField(default=False)

    # Amanah Score (FR13-14)
    amanah_score = models.IntegerField(default=0)

    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    # Use email as the login identifier
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username', 'first_name', 'last_name']

    email = models.EmailField(unique=True)

    class Meta:
        db_table = 'amanah_users'
        verbose_name = 'Amanah User'
        verbose_name_plural = 'Amanah Users'

    def __str__(self):
        return f"{self.email} ({'Scholar' if self.is_scholar else 'User'})"

    @property
    def full_name(self):
        return f"{self.first_name} {self.last_name}".strip()

    @property
    def age(self):
        if self.date_of_birth:
            from datetime import date
            today = date.today()
            dob = self.date_of_birth
            return today.year - dob.year - ((today.month, today.day) < (dob.month, dob.day))
        return None