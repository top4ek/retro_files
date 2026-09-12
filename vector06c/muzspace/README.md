---
name: Covox sample
id: 821
tags:
  - demo
  - disk
  - music
authors:
  - spase_corporation
---

Семплерная демонстрационная программа-проигрыватель.
Перенесена с IBM PC.

Для вывода звука используется ЦАП (COVOX).

На диске три мелодии: Чип и Дейл, Samantha Fox, Буратино.

Для подключения COVOX в [эмуляторе «Башкирия-2М»](../bashkiria_2m), в файле vector.cfg нужно прописать секцию:

ext : K580ww55 {

  portA=extrom.lsb

  portA=AY.covox[0-7]

  portB=extrom.data

  portC[0-6]=extrom.msb

}

но при этом будет невозможна загрузка из модуля внешнего ПЗУ.
