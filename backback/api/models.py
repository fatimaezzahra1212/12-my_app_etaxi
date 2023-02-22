from django.contrib.auth.models import AbstractUser
from django.db import models
from django.conf import settings

#otp-verification
# models.py

from django.db import models
from django_otp.models import Device, ThrottlingMixin

class OTPDevice(ThrottlingMixin, Device):
    name = models.CharField(max_length=64, blank=True, null=True)
    num_tries = models.PositiveIntegerField(default=0)
#otp-verification
class User(AbstractUser):
    
    profilepic = models.ImageField(max_length=100)
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    num = models.CharField(max_length=20)
    email = models.EmailField(unique=True, blank=True, null=True)
    #password = models.CharField(max_length=100)
    #confirmpassword = models.CharField(max_length=100)
    title = models.CharField(max_length=100, default='Default Title')

    def __str__(self):
        return self.title

    def create_user(self, username, email=None, password=None, **extra_fields):
        if not email:
            raise ValueError('The Email field must be set')
        email = self.normalize_email(email)
        user = self.model(username=email, email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user


class Driver(User):
    emailname = models.EmailField(blank=True, null=True)
    licenses = models.ImageField(max_length=100)
    nationalIdentity = models.ImageField(max_length=100)
    taxiCard = models.ImageField(max_length=100)
    photoTaxi = models.ImageField(max_length=100)
    numberTaxi = models.ImageField(max_length=100)

    def __str__(self):
        return self.title


class UserLocation(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    latitude = models.FloatField()
    longitude = models.FloatField()
    is_online = models.BooleanField(default=False)