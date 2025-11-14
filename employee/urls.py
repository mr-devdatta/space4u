from django.urls import URLPattern, path
from .views import EmployeeView


urlpatterns = [
    path('test/', EmployeeView.as_view(), name='employee_test'),
]
