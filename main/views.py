from django.shortcuts import render
from django.http import HttpResponse
from django.core.files.storage import default_storage
import os
from django.contrib.auth.decorators import login_required
from .models import *
from .forms import *
import mimetypes


# Главная страница
def main(request):
    data = {

    }

    site = render(request, 'main/index.html', data)

    return site


@login_required
def subjectDetail(request, subject_id):
    subj = subject.objects.get(pk=subject_id)
    exeCount = 0

    # генеирурем словарь заданий студентов
    dict_ = {}
    for i in subj.student.all():
        dict_[i] = subj.exercise.filter(student=i).order_by("name")

    # Получаем максимальное количество предметов среди аккаунтов студентов
    for i in dict_.keys():
        count = dict_[i].count()
        if count > exeCount:
            exeCount = count

    data = {
        'subject': subj,
        'dict': dict_,
        'students': dict_.keys(),
        'exerciseCount': exeCount
    }

    site = render(request, 'main/detail_subject.html', data)
    return site


@login_required
def detailExe(request, subject_id, exercise_id):
    if request.method == "POST":
        try:
            exer = exercise.objects.get(pk=exercise_id)
            grade = request.POST.get("grade")

            exer.grade = grade

            if not exer.complete:
                exer.complete = True

            exer.save()

        except Exception:
            ...

    exer = exercise.objects.get(pk=exercise_id)
    files = []

    for i in exer.upload:
        files.append(i.split('/')[-1])

    data = {
        'exercise': exer,
        'subject_id': subject_id,
        'upload': files,
        'uploadRange': [i for i in range(0, len(files))]
    }

    site = render(request, 'main/detail_exercise.html', data)
    return site


@login_required
def downloadFile(request, username, filename):
    fl_path = f'uploads/{username}/{filename}'

    fl = open(fl_path, 'r')
    mime_type, _ = mimetypes.guess_type(fl_path)
    response = HttpResponse(fl, content_type=mime_type)
    response['Content-Disposition'] = "attachment; filename=%s" % filename
    return response


@login_required
def updateExeFiles(request, subject_id, exercise_id):
    data = {
        'exercise': exercise.objects.get(pk=exercise_id),
        'subject_id': subject_id,
    }

    if request.method == 'POST':
        form = FileFieldForm(request.POST, request.FILES)
        files = request.FILES.getlist('file')  # Получаем загруженные файлы

        exer = exercise.objects.get(pk=exercise_id)

        for i in files:
            # Создаем файл в нужном каталоге
            file_path = os.path.join(f"uploads/{exer.student.username}/{str(i)}")
            fout = open(file_path, 'wb+')
            fout.write(i.read())
            fout.close()

            exer.upload.append(file_path)

        exer.save()

    else:

        form = FileFieldForm()

    data['form'] = form
    site = render(request, 'main/exercise_files.html', data)
    return site


# Страница с предметами, относящиеся к пользователю
@login_required
def subjectList(request):
    if request.user.groups.filter(name='student').exists():
        sub = subject.objects.all().filter(student=request.user)
        data = {
            'subjects': sub,
        }

    elif request.user.groups.filter(name='teacher').exists():
        sub = subject.objects.all().filter(teacher=request.user)

        data = {
            'subjects': sub,
        }

    site = render(request, 'main/subjects.html', data)
    return site
