from django.urls import path
from .views import ClientListView, ClientCreateView, ClientUpdateView, ClientDeleteView, ClientProjectsView, ClientSearchView

urlpatterns = [
    path('', ClientListView.as_view(), name='client_list'),
    path('new/', ClientCreateView.as_view(), name='client_create'),
    path('<int:pk>/', ClientUpdateView.as_view(), name='client_update'),
    path('<int:pk>/delete/', ClientDeleteView.as_view(), name='client_delete'),
    path('<int:pk>/projects/', ClientProjectsView.as_view(), name='client_projects'),
    path('search/', ClientSearchView.as_view(), name='client_search'),
]
