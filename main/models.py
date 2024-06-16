from django.db import models
from django import template
import os
from django.contrib.postgres.fields import ArrayField
from django.contrib.auth.models import Group
from django.contrib.auth.models import User
import uuid


def user_directory_path(instance, filename):
    # file will be uploaded to MEDIA_ROOT/user_<id>/<filename>
    path = f"uploads/{instance.student.username}/{filename}"

    return f"uploads/{instance.student.username}/{filename}"


# Модель задания
class exercise(models.Model):
    name = models.CharField(max_length=100)
    grade = models.IntegerField()
    max_grade = models.IntegerField()
    student = models.ForeignKey(User,
                                on_delete=models.CASCADE,
                                blank=True,
                                null=True,
                                limit_choices_to={'groups': 1},
                                )

    complete = models.BooleanField()
    upload = ArrayField(models.FileField(upload_to=user_directory_path, blank=True, null=True), null=True, blank=True)

    def __str__(self):
        return f"{self.name} - {self.student.username}"

    class Meta:
        unique_together = ('name', 'student')


# Модель учебного предмета
class subject(models.Model):
    name = models.CharField(max_length=100)
    teacher = models.ForeignKey(User,
                                related_name='teacher',
                                on_delete=models.CASCADE,
                                blank=True,
                                null=True,
                                limit_choices_to={'groups': 2},
                                )

    student = models.ManyToManyField(User,
                                     limit_choices_to={'groups': 1},
                                     )

    exercise = models.ManyToManyField(exercise, blank=True)

    def __str__(self):
        return f"{self.name}"

