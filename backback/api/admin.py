from django.contrib import admin
from .models import User
from .models import Driver

from . import models
# Register your models here.
#@admin.register(User)
#class UserAdmin(admin.ModelAdmin):
# list_display = ['id']
admin.site.register(models.User)
admin.site.register(models.Driver)
#@admin.register(Driver)
#class DriverAdmin(admin.ModelAdmin):
# list_display = [ 'id']