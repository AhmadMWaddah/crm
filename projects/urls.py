from django.urls import path
from .views import ProjectListView, ProjectCreateView, ProjectUpdateView, ProjectDeleteView

urlpatterns = [
    path('', ProjectListView.as_view(), name='project_list'),
    path('new/', ProjectCreateView.as_view(), name='project_create'),
    path('<int:pk>/', ProjectUpdateView.as_view(), name='project_update'),
    path('<int:pk>/delete/', ProjectDeleteView.as_view(), name='project_delete'),
]
