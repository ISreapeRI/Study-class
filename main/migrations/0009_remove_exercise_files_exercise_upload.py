# Generated by Django 4.0.2 on 2024-03-19 14:08

from django.db import migrations, models
import main.models


class Migration(migrations.Migration):

    dependencies = [
        ('main', '0008_alter_exercise_files'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='exercise',
            name='files',
        ),
        migrations.AddField(
            model_name='exercise',
            name='upload',
            field=models.FileField(blank=True, null=True, upload_to=main.models.user_directory_path),
        ),
    ]
