from rest_framework import generics, viewsets, status
from rest_framework.generics import ListAPIView 
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from dj_rest_auth.registration.views import RegisterView
from .models import User, Driver, UserLocation
from .serializers import UserSerializer, DriverSerializer, UserLocationSerializer, NewRegisterSerializer, DriverRegisterSerializer
from .models import User
from .serializers import UserSerializer
from .models import Driver
from .serializers import  DriverSerializer
from rest_framework import generics, serializers
from rest_framework.generics import ListAPIView 
from rest_framework import generics, permissions
from dj_rest_auth.registration.views import RegisterView
from .serializers import UserSerializer,NewRegisterSerializer,DriverRegisterSerializer,UserSerializer
from rest_framework import viewsets
from .serializers import UserLocationSerializer
from .models import UserLocation
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
#from .utils import get_client_i
from .utils import get_client_ip
from rest_framework.response import Response
from rest_framework.views import APIView
#otp
from django_otp import devices_for_user
from django_otp.plugins.otp_totp.models import TOTPDevice
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .serializers import OTPVerificationSerializer
#otp-verificatio
# views.py

from django.http import JsonResponse
from django_otp.oath import TOTP
from django_otp.plugins.otp_totp.models import TOTPDevice
from django_otp.util import random_hex

def send_otp(request):
    phone_number = request.GET.get('phone_number')
    if not phone_number:
        return JsonResponse({'error': 'Phone number is required.'}, status=400)
    try:
        device = TOTPDevice.objects.get(name=phone_number)
    except TOTPDevice.DoesNotExist:
        device = TOTPDevice.objects.create(name=phone_number)
        device.bin_key = random_hex(20)
        device.save()
    totp = TOTP(device.bin_key)
    otp_code = totp.generate_otp()
    device.num_tries = 0
    device.throttle_reset()
    device.save()
    # TODO: Send OTP code to the phone number using a messaging service
    return JsonResponse({'message': 'OTP code sent successfully.'})

def verify_otp(request):
    phone_number = request.GET.get('phone_number')
    otp_code = request.GET.get('otp_code')
    if not phone_number or not otp_code:
        return JsonResponse({'error': 'Phone number and OTP code are required.'}, status=400)
    try:
        device = TOTPDevice.objects.get(name=phone_number)
    except TOTPDevice.DoesNotExist:
        return JsonResponse({'error': 'No OTP device found for this phone number.'}, status=400)
    totp = TOTP(device.bin_key)
    num_tries = device.num_tries
    if num_tries >= device.get_throttle_factor():
        device.throttle_increment()
        return JsonResponse({'error': 'Too many attempts. Try again later.'}, status=429)
    if not totp.verify(otp_code):
       device.num_tries = num_tries + 1
       device.save()
       if num_tries + 1 >= device.get_throttle_factor():
          device.throttle_increment()
    return JsonResponse({'error': 'Invalid OTP code.'}, status=400)
    device.num_tries = 0
    device.throttle_reset()
    device.save()
    # TODO: Return an access token or some other form of authentication to the client
    return JsonResponse({'message': 'OTP verification successful.'})
class OTPVerificationView(APIView):
    def post(self, request):
        serializer = OTPVerificationSerializer(data=request.data)
        if serializer.is_valid():
            otp = serializer.validated_data['otp']
            user = request.user
            devices = devices_for_user(user)
            if len(devices) > 0 and isinstance(devices[0], TOTPDevice):
                if devices[0].verify(otp):
                    return Response({'success': True}, status=status.HTTP_200_OK)
            return Response({'success': False, 'error': 'Invalid OTP'}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
#otp        
class MyView(APIView):
    def get(self, request):
        data = {"message": "Hello, world!"}
        return Response(data)
class NewRegistrationView(RegisterView):
    serializer_class = NewRegisterSerializer

    def perform_create(self, serializer):
        user = serializer.save(self.request)
        data = {'user_id': user.id, 'email': user.email, 'first_name': user.first_name, 'last_name': user.last_name}
        return Response(data, status=status.HTTP_201_CREATED)

class DriverRegistrationView(RegisterView):
    serializer_class = DriverRegisterSerializer

class DriverGetCreate(generics.ListCreateAPIView):
    queryset = Driver.objects.all()
    serializer_class = DriverSerializer

class DriverUpdateDelete(generics.RetrieveUpdateDestroyAPIView):
    queryset = Driver.objects.all()
    serializer_class = DriverSerializer

class UserList(ListAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer

class UserGetCreate(generics.ListCreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer

class UserUpdateDelete(generics.RetrieveUpdateDestroyAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer





class UserLocationViewSet(viewsets.ModelViewSet):
    queryset = UserLocation.objects.all()
    serializer_class = UserLocationSerializer

@csrf_exempt
def set_user_location(request):
    ip_address = get_client_ip(request)
    user = request.user
    latitude = request.POST.get('latitude')
    longitude = request.POST.get('longitude')

    if user and latitude and longitude:
        user_location, created = UserLocation.objects.get_or_create(user=user, defaults={'latitude': latitude, 'longitude': longitude})
        user_location.is_online = True
        user_location.save()

    return JsonResponse({'status': 'success'})

@csrf_exempt
def online_users(request):
    online_users = UserLocation.objects.filter(is_online=True)
    data = {
        "online_users": [{"latitude": user.latitude, "longitude": user.longitude} for user in online_users]
    }
    return JsonResponse(data)