from django.urls import path
from django.conf.urls.static import static
from django.conf import settings
from main import views, forms

urlpatterns = [
    path('', views.main, name="main"),
    path('subjects/', views.subjectList, name="subjects"),
    path('subjects/<int:subject_id>', views.subjectDetail, name='subject-detail'),
    path('subjects/<int:subject_id>/exercise/<int:exercise_id>', views.detailExe, name='exercise-detail'),
    path('subjects/<int:subject_id>/exercise/<int:exercise_id>/files', views.updateExeFiles, name='exercise-files-update'),
    path('uploads/<str:username>/<str:filename>', views.downloadFile, name='download-file'),
] + static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)