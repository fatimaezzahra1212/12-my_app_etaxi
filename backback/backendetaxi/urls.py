from django.contrib import admin
from django.urls import path,include
from django.urls import path,include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('api.urls')),
    path('', include('dj_rest_auth.urls')),
    #path('notif/', include('notification.urls')),
    path('registration/', include('dj_rest_auth.registration.urls')),
    path('account/', include('allauth.urls')),
]   