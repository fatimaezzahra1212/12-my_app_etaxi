from django.apps import AppConfig

from django.apps import apps

#EmailAddress = apps.get_model('allauth.account', 'EmailAddress')
class ApiConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'api'
