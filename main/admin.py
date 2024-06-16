from django.contrib import admin
from import_export.admin import ImportExportModelAdmin
from import_export import resources
from .models import *


# Ресурсы моделей
class subjectResource(resources.ModelResource):
    class Meta:
        model = subject


class exerciseResource(resources.ModelResource):
    class Meta:
        model = exercise

        # Используемые поля
        fields = ('id', 'name', 'student__first_name', 'grade', 'max_grade', 'complete',)

        # Порядок полей для импорта
        import_order = ('id', 'name', 'student__first_name', 'grade', 'max_grade', 'complete')

        # Порядок полей для экспорта
        export_order = ('id', 'name', 'student__first_name', 'grade', 'max_grade', 'complete')


# Ресурсы для импорта\экспорта моделей
class subjectAdmin(ImportExportModelAdmin):
    resource_classes = [subjectResource]


class exerciseAdmin(ImportExportModelAdmin):
    resource_classes = [exerciseResource]


admin.site.register(subject, subjectAdmin)
admin.site.register(exercise, exerciseAdmin)


