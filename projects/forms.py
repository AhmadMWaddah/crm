from django import forms
from projects.models import Project


class ProjectForm(forms.ModelForm):
    """Form for creating and updating projects."""
    
    class Meta:
        model = Project
        fields = ['name', 'description', 'status', 'rate', 'client']
        widgets = {
            'name': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Project name'}),
            'description': forms.Textarea(attrs={'class': 'form-control', 'placeholder': 'Project description', 'rows': 4}),
            'status': forms.Select(attrs={'class': 'form-control'}),
            'rate': forms.NumberInput(attrs={'class': 'form-control', 'step': '0.01'}),
            'client': forms.Select(attrs={'class': 'form-control'}),
        }
