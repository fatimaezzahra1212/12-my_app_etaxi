from django.db import IntegrityError
from django.contrib.auth import authenticate
from rest_framework import serializers
from dj_rest_auth.serializers import LoginSerializer
from dj_rest_auth.registration.serializers import RegisterSerializer
from .models import User, Driver, UserLocation


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'

class OTPVerificationSerializer(serializers.Serializer):
    otp = serializers.CharField(max_length=6)
class NewRegisterSerializer(RegisterSerializer):
    profilepic = serializers.ImageField()
    first_name = serializers.CharField(required=True)
    last_name = serializers.CharField(required=True)
    num = serializers.CharField(required=True)
    email = serializers.EmailField(required=True)
    password1 = serializers.CharField(write_only=True)
    password2 = serializers.CharField(write_only=True)

    def get_cleaned_data(self):
        data = super().get_cleaned_data()
        return {
            'profilepic': self.validated_data.get('profilepic', ''),
            'password1': data['password1'],
            'password2': data['password1'],
            'first_name': self.validated_data.get('first_name', ''),
            'last_name': self.validated_data.get('last_name', ''),
            'num': self.validated_data.get('num', ''),
            'email': self.validated_data.get('email', ''),
        }

    def custom_signup(self, request, user):
        user.profilepic = request.data.get('profilepic', None)
        user.first_name = request.data['first_name']
        user.last_name = request.data['last_name']
        user.num = request.data['num']
        user.email = request.data['email']
        user.save()


class DriverSerializer(UserSerializer):
    class Meta:
        model = Driver
        fields = '__all__'

    def create(self, validated_data):
        user_data = {
            'first_name': validated_data['first_name'],
            'last_name': validated_data['last_name'],
            'num': validated_data['num'],
            'email': validated_data['email'],
            'profilepic': validated_data.get('profilepic', None),
        }
        driver = Driver.objects.create(**validated_data)
        User.objects.create(user=driver, **user_data)
        return driver


class DriverRegisterSerializer(NewRegisterSerializer):
    licenses = serializers.ImageField(required=True)
    nationalIdentity = serializers.ImageField(required=True)
    taxiCard = serializers.ImageField(required=True)
    photoTaxi = serializers.ImageField(required=True)
    numberTaxi = serializers.CharField(required=True)

    def get_cleaned_data(self):
        data = super().get_cleaned_data()
        return {
            'licenses': self.validated_data.get('licenses', ''),
            'nationalIdentity': self.validated_data.get('nationalIdentity', ''),
            'taxiCard': self.validated_data.get('taxiCard', ''),
            'photoTaxi': self.validated_data.get('photoTaxi', ''),
            'numberTaxi': self.validated_data.get('numberTaxi', ''),
            **data
        }

    def custom_signup(self, request, user):
        user.licenses = request.data['licenses']
        user.nationalIdentity = request.data['nationalIdentity']
        user.taxiCard = request.data['taxiCard']
        user.numberTaxi = request.data['numberTaxi']
        user.photoTaxi = request.data['photoTaxi']
        user.save()


class NewLoginSerializer(LoginSerializer):
    class Meta:
        model = User
        fields = ('email', 'password')

    def validate(self, attrs):
        user = authenticate(request=self.context.get('request'), **attrs)

        if not user:
            raise serializers.ValidationError('Invalid login credentials. Please try again.')

        if not user.is_active:
            raise serializers.ValidationError('This user has been deactivated.')


class UserLocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserLocation
        fields = ('id', 'user', 'latitude', 'longitude', 'is_online')
