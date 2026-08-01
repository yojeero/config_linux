сброс пароля Windows из под Linux

Просмотрите список дисков/разделов
# fdisk -l
/dev/sda1 *
/dev/sda2
Если список слишком большой, воспользуйтесь командой more:

# fdisk -l | more
Смонтируйте раздел/диск с Windows
# mount /dev/sda2 /mnt
Проверьте, тот ли диск вы примонтировали, по его содержимому
# ls -l /mnt
Если вы ошиблись, отмонтируйте диск

# umount /mnt
и повторите шаг 2

Перейдите в следующий каталог:
# cd /mnt/Windows/System32/config/
! В Linux в имени файлов регистр имеет значение, соблюдайте его.

Чтобы просмотреть список учетных записей Windows введите следующую команду:
# chntpw -l SAM
Отобразится, приблизительно, следующее:

| RID -|---------- Username -------------| Admin?|- Lock? --|
| 01f4 | Администратор                   | ADMIN | dis/lock |     //учетная запись встроенного администратора
| 03ea | Петр                            |       |dis/Lock  |     //созданный пользователь
| 01f5 | Гость                           |       | *BLANK*  |     //учетная запись гостя
| 03eb | root                            | ADMIN | dis/lock |     //созданный пользователь с правами администратора
Чтобы приступить к редактированию учетной записи, введите команду
# chntpw -u 0xRID SAM
В нашем примере

# chntpw -u 0x03eb SAM
Появится следующее окно:
| RID -|---------- Username -------------| Admin?|- Lock? --|
| 01f4 | Администратор                   | ADMIN | dis/lock |
| 03ea | Петр                            |       |dis/Lock  |
| 01f5 | Гость                           |       | *BLANK*  |
| 03eb | root                            | ADMIN | dis/lock |

- - - - User Edit Menu:
1 - Clear (blank) user password
2 - Edit (set new) user password (careful with this on XP or Vista)
3 - Promote user (make user an administrator)
4 - Unlock and enable user account [probably locked now]
q - Quit editing user, back to user select
Select:
! В разных версиях программы пункты могут идти в разном порядке.

Учетная запись скорее всего будет заблокирована, введите номер пункта "Unlock and enable user account [probably locked now]", чтобы разблокировать учетную запись и согласитесь с записью изменений введя y.
Чтобы сбросить пароль снова введите
# chntpw -u 0x03eb SAM
и на этот раз введите номер пункта "Clear (blank) user password", чтобы произвести сброс пароля.

Проверьте результат сброса командой
# chntpw -l SAM
| RID -|---------- Username -------------| Admin?|- Lock? --|
| 01f4 | Администратор                   | ADMIN | dis/lock |
| 03ea | Петр                            |       |dis/Lock  |
| 01f5 | Гость                           |       | *BLANK*  |
| 03eb | root                            | ADMIN |  *BLANK* | //пароль пустой

После перезагрузки в Windows у вас данная учетная запись будет без пароля.