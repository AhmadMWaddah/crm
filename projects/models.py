from django.conf import settings
from django.db import models
from clients.models import Client


class Project(models.Model):
    """
    Represents a project linked to a client.
    Each project belongs to a specific user.
    """
    STATUS_CHOICES = [
        ('active', 'Active'),
        ('completed', 'Completed'),
        ('on_hold', 'On Hold'),
    ]

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='projects'
    )
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True, null=True)
    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default='active'
    )
    rate = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        help_text='Hourly rate in EGP'
    )
    client = models.ForeignKey(
        Client,
        on_delete=models.CASCADE,
        related_name='projects'
    )
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.name} ({self.client.name})'
