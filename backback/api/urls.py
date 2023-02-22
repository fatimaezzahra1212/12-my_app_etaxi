from django.urls import path,include
from api import views
from .views import UserGetCreate ,UserUpdateDelete ,DriverGetCreate,DriverUpdateDelete,NewRegistrationView,DriverRegistrationView
from django.urls import path
from django.conf.urls import include
from rest_framework import routers
from .views import UserLocationViewSet, set_user_location, online_users,MyView
from .views import OTPVerificationView
router = routers.DefaultRouter()  
router.register(r'locations', UserLocationViewSet)
from . import views
urlpatterns = [
    #otp-verification
    path('send_otp/', views.send_otp, name='send_otp'),
    path('verify_otp/', views.verify_otp, name='verify_otp'),

    path('otp-verification/', OTPVerificationView.as_view(), name='otp-verification'),
    path('message', MyView.as_view, name='home'),
    path('local', include(router.urls)),
    path('set_location/', set_user_location, name='set_user_location'),
    path('online_users/', online_users, name='online_users'),

    path('user/', UserGetCreate.as_view()),
    path('<int:pk>', UserUpdateDelete.as_view()),
    path('driver/', DriverGetCreate.as_view()),
    path('<int:pk>', DriverUpdateDelete.as_view()),
    path('auth/',include('dj_rest_auth.urls')),
    path('auth/registration/',include('dj_rest_auth.registration.urls')),
    path('auth/registration/user/', NewRegistrationView.as_view()),
    path('auth/registration/driver/', DriverRegistrationView.as_view()),


]