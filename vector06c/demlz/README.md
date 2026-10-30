---
name: DeMLZ
id: 691
date: 2009
tags:
  - development
  - packer
  - sourcecode
authors:
  - ivagor
---

Распаковщик для архиватора MegaLZ - [http://lvd.nm.ru/MegaLZ/](http://lvd.nm.ru/MegaLZ/)

Рекомпилирован из варианта распаковщика для Z80. Использовался рекомпилятор Александра Тимошенко - [http://vector06c.narod.ru/](http://vector06c.narod.ru/)  и ручная оптимизация

Использование распаковщика аналогично варианту для Z80:

HL - адрес упакованных данных

DE - куда распаковывать

Вызов CALL DEC40

Компилировать с использованием ассемблера The Telemark Assembler (TASM) Version 3.2 (автор Thomas N. Anderson) (архив легко находится любым поисковиком по запросу tasm32.zip)

В качестве примера приложен sfx архив BASIC 2.5 для компьютера Вектор-06Ц.
