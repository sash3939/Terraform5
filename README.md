# Домашнее задание к занятию «Использование Terraform в команде»

### Цели задания

1. Научиться использовать remote state с блокировками.
2. Освоить приёмы командной работы.

## Задание 1

1. Возьмите код:
- из ДЗ к лекции 4
- из демо к лекции 4
2. Проверьте код с помощью tflint и checkov. Вам не нужно инициализировать этот проект.
3. Перечислите, какие **типы** ошибок обнаружены в проекте (без дублей).
### tflint
- не указана версия провайдера
```
Warning: Missing version constraint for provider "yandex" in `required_providers` (terraform_required_providers)
```
- исходный код модуля использует ветку main как дефолтную итак
```
Warning: Module source "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main" uses a default branch as ref (main) (terraform_module_pinned_source)
```
- Переменная объявлена но не была использована
```
Warning: [Fixable] variable "public_key" is declared but not used (terraform_unused_declarations)
```
### checkov
- убедиться, что инстанс не имеет публичного IP.
```
Check: CKV_YC_2: "Ensure compute instance does not have public IP."
        FAILED for resource: module.test-vm.yandex_compute_instance.vm[0]
        File: /.external_modules/github.com/udjin10/yandex_compute_instance/main/main.tf:24-73
        Calling File: /main.tf:25-41
```
- убедиться, что группа безопасности назначена сетевому интерфейсу.
```
heck: CKV_YC_11: "Ensure security group is assigned to network interface."
        FAILED for resource: module.test-vm.yandex_compute_instance.vm[0]
        File: /.external_modules/github.com/udjin10/yandex_compute_instance/main/main.tf:24-73
        Calling File: /main.tf:25-41
```
- убедиться что используется хэш коммита
```
heck: CKV_TF_1: "Ensure Terraform module sources use a commit hash"
        FAILED for resource: test-vm
        File: /main.tf:25-41
```
------

## Задание 2

1. Возьмите ваш GitHub-репозиторий с **выполненным ДЗ 4** в ветке 'terraform-04' и сделайте из него ветку 'terraform-05'.
2. Повторите демонстрацию лекции: настройте YDB, S3 bucket, yandex service account, права доступа и мигрируйте state проекта в S3 с блокировками. Предоставьте скриншоты процесса в качестве ответа.
   ![image](https://github.com/LexNezv/devops-netology/assets/60059176/291c234e-c671-43b4-b278-8977528436a1)
   ![image](https://github.com/LexNezv/devops-netology/assets/60059176/7abdc167-b3bb-482a-b442-efa834791bb3)
   ![image](https://github.com/LexNezv/devops-netology/assets/60059176/3db4b0dd-8ad9-42d8-b845-156b6e6bf07a)
   ![image](https://github.com/LexNezv/devops-netology/assets/60059176/c19f41a1-30df-4d02-8f86-6ba947055f83)
   ![image](https://github.com/LexNezv/devops-netology/assets/60059176/6f909ccc-0d3a-44f9-8ff3-fe63efd619c6)
   ![image](https://github.com/LexNezv/devops-netology/assets/60059176/9eef0939-bf6c-485b-acb4-5c2199db7fbd)
   ![image](https://github.com/LexNezv/devops-netology/assets/60059176/2045bb6f-4297-4ac1-9933-b3f4361ffd0d)
   ![image](https://github.com/LexNezv/devops-netology/assets/60059176/a02b7959-b44a-453e-82b7-2a36a1addbff)
   
   
4. Закоммитьте в ветку 'terraform-05' все изменения.
5. Откройте в проекте terraform console, а в другом окне из этой же директории попробуйте запустить terraform apply.
6. Пришлите ответ об ошибке доступа к state.
   
   ![image](https://github.com/LexNezv/devops-netology/assets/60059176/3080f2d1-b837-484e-890e-5302b6361f8e)

8. Принудительно разблокируйте state. Пришлите команду и вывод.
   ```
   terraform force-unlock e51d9fcf-4801-5eb0-774a-ce1df7ca5940
   ```
   Вывод:
   ```

   Do you really want to force-unlock?
   Terraform will remove the lock on the remote state.
   This will allow local Terraform commands to modify this state, even though it
   may still be in use. Only 'yes' will be accepted to confirm.

   Enter a value: yes

   Terraform state has been successfully unlocked!

   The state has been unlocked, and Terraform commands should now be able to
   obtain a new lock on the remote state.
   ```


------
## Задание 3  

1. Сделайте в GitHub из ветки 'terraform-05' новую ветку 'terraform-hotfix'.
2. Проверье код с помощью tflint и checkov, исправьте все предупреждения и ошибки в 'terraform-hotfix', сделайте коммит.
3. Откройте новый pull request 'terraform-hotfix' --> 'terraform-05'. 
4. Вставьте в комментарий PR результат анализа tflint и checkov, план изменений инфраструктуры из вывода команды terraform plan.
5. Пришлите ссылку на PR для ревью. Вливать код в 'terraform-05' не нужно.

------
## Задание 4

1. Напишите переменные с валидацией и протестируйте их, заполнив default верными и неверными значениями. Предоставьте скриншоты проверок из terraform console. 

- type=string, description="ip-адрес" — проверка, что значение переменной содержит верный IP-адрес с помощью функций cidrhost() или regex(). Тесты:  "192.168.0.1" и "1920.1680.0.1";
- type=list(string), description="список ip-адресов" — проверка, что все адреса верны. Тесты:  ["192.168.0.1", "1.1.1.1", "127.0.0.1"] и ["192.168.0.1", "1.1.1.1", "1270.0.0.1"].


![image](https://github.com/LexNezv/devops-netology/assets/60059176/2c4ddfa5-c637-49bc-b5a7-091741cb2656)


## Дополнительные задания (со звёздочкой*)
------
## Задание 5*
1. Напишите переменные с валидацией:
- type=string, description="любая строка" — проверка, что строка не содержит символов верхнего регистра;
- type=object — проверка, что одно из значений равно true, а второе false, т. е. не допускается false false и true true:
```
variable "in_the_end_there_can_be_only_one" {
    description="Who is better Connor or Duncan?"
    type = object({
        Dunkan = optional(bool)
        Connor = optional(bool)
    })

    default = {
        Dunkan = true
        Connor = false
    }

    validation {
        error_message = "There can be only one MacLeod"
        condition = <проверка>
    }
}
```

![image](https://github.com/LexNezv/devops-netology/assets/60059176/11164a56-b7f0-4ac1-85b1-46f4862d63b1)

------
## Задание 6*

1. Настройте любую известную вам CI/CD-систему. Если вы ещё не знакомы с CI/CD-системами, настоятельно рекомендуем вернуться к этому заданию после изучения Jenkins/Teamcity/Gitlab.
2. Скачайте с её помощью ваш репозиторий с кодом и инициализируйте инфраструктуру.
3. Уничтожьте инфраструктуру тем же способом.

![image](https://github.com/LexNezv/devops-netology/assets/60059176/ea63b5b4-5438-4d1f-a1cd-c38f0fa10887)
![image](https://github.com/LexNezv/devops-netology/assets/60059176/0cc27c4e-4100-4e17-9cd1-223a52f6dd8b)
![image](https://github.com/LexNezv/devops-netology/assets/60059176/8d453eed-dae3-40a0-80ee-d54e5a84f78a)
![image](https://github.com/LexNezv/devops-netology/assets/60059176/3c1e13e3-be66-4f3c-a4ce-86766285fcaf)



------
## Задание 7*
1. Настройте отдельный terraform root модуль, который будет создавать YDB, s3 bucket для tfstate и сервисный аккаунт с необходимыми правами. 

