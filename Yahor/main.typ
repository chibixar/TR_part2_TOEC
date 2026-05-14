#import "@preview/modern-g7-32:0.2.0": *
#import "@local/typst-bsuir-core:1.1.1": *
#import "@preview/zap:0.5.0"

#set text(font: "Times New Roman", size: 14pt)
#show math.equation: set text(font: "STIX Two Math", size: 14pt)

#show: gost.with(
  title-template: custom-title-template.from-module(toec-typical-template),
  department: "Кафедра теоретических основ электротехники",
  work: (
    type: "Типовой расчет по курсу: «Теория электрических цепей»",
    number: "",
    subject: "Расчет сложной цепи периодического синусоидального тока",
    variant: "558301-17",
  ),
  manager: (
    name: "Батюков С.В.",
  ),
  performer: (
    name: "Капшуль Е.А.", // Замените на ваши ФИО
    group: "558301",
  ),
  footer: (city: "Минск", year: 2026),
  city: none,
  year: none,
  add-pagebreaks: false,
  text-size: 14pt,
)

#show: apply-toec-styling

// Полностью убираем нумерацию страниц
#set page(numbering: none, footer: none)

= Расшифровка задания

#figure(
  caption: none,
  table(
    columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto),
    align: center + horizon,
    table.header(
      table.cell(rowspan: 2)[Номер\ ветви],
      table.cell(rowspan: 2)[Начало-\ конец],
      table.cell(colspan: 3)[Сопротивления, Ом],
      table.cell(colspan: 2)[Источник ЭДС],
      table.cell(colspan: 2)[Источник тока],
      [$R$], [$X_L$], [$X_C$],
      [Мод., В], [Арг., $degree$],
      [Мод., А], [Арг., $degree$]
    ),
    [1], [45], [55], [0], [0], [0], [0], [0], [0],
    [2], [56], [0], [66], [48], [0], [0], [1], [343],
    [3], [63], [0], [97], [0], [0], [0], [0], [0],
    [4], [31], [94], [0], [98], [0], [0], [0], [0],
    [5], [12], [0], [13], [53], [21], [344], [0], [0],
    [6], [24], [35], [68], [0], [0], [0], [0], [0],
    [7], [51], [16], [0], [55], [0], [0], [0], [0],
  )
)

Найти токи по методу эквивалентных преобразований. Составить баланс мощностей. Построить векторную диаграмму токов и напряжений. Найти ток в ветви 7 МЭГН.

На рисунке 1 изображена исходная схема.

#lab-figure(
  caption: [Исходная схема],
  [
    #v(-0.5cm)
    #circuit-better(scale-factor: 70%, {
      import zap: *
      // Узлы разнесены для избежания наложений
      node-better("1", (8, 0), label: (content: "1", anchor: "south", distance: 0.5), visible: true)
      node-better("5", (8, 12), label: (content: "5", anchor: "north-west", distance: 0.8), visible: true)
      node-better("2", (0, 0), label: (content: "2", anchor: "south-west", distance: 0.5), visible: true)
      node-better("4", (0, 12), label: (content: "4", anchor: "north-west", distance: 0.5), visible: true)
      node-better("6", (16, 12), label: (content: "6", anchor: "north-east", distance: 0.5), visible: true)
      node-better("3", (16, 0), label: (content: "3", anchor: "south-east", distance: 0.5), visible: true)

      // Ветвь 5 (1 -> 2)
      source-better("E5", "1", (5,0), label: (content: $E_5$, anchor: "south", distance: 1.2), arrow-dir: "forward")
      inductor-better("L5", (2.5,0), (5,0), label: (content: $L_5$, anchor: "south", distance: 1.2)) // изменено направление для отображения катушкой вверх
      capacitor-better("C5", (2.5,0), "2", label: (content: $C_5$, anchor: "south", distance: 1.2), arrow-label: (content: $I_5$, anchor: "north", distance: 1.2), arrow-side: "north", arrow-dir: "forward")

      // Ветвь 6 (2 -> 4)
      resistor-better("R6", "2", (0,6), label: (content: $R_6$, anchor: "east", distance: 1.2), arrow-label: (content: $I_6$, anchor: "west", distance: 1.2), arrow-side: "west")
      inductor-better("L6", (0,6), "4", label: (content: $L_6$, anchor: "east", distance: 1.2))

      // Ветвь 1 (4 -> 5)
      resistor-better("R1", "4", "5", label: (content: $R_1$, anchor: "south", distance: 1.2), arrow-label: (content: $I_1$, anchor: "north", distance: 1.2), arrow-side: "north")

      // Ветвь 7 (5 -> 1)
      resistor-better("R7", "5", (8,6), label: (content: $R_7$, anchor: "east", distance: 1.2), arrow-label: (content: $I_7$, anchor: "west", distance: 1.2), arrow-side: "west")
      capacitor-better("C7", (8,6), "1", label: (content: $C_7$, anchor: "east", distance: 1.2))

      // Ветвь 2 (5 -> 6)
      inductor-better("L2", "5", (12,12), label: (content: $L_2$, anchor: "south", distance: 1.2), arrow-label: (content: $I_2$, anchor: "north", distance: 1.2), arrow-side: "north")
      capacitor-better("C2", (12,12), "6", label: (content: $C_2$, anchor: "south", distance: 1.2))

      // Источник тока J2 параллельно ветви 2
      wire("5", (8,15))
      jsource-better("J2", (8,15), (16,15), label: (content: $J_2$, anchor: "north", distance: 1.2), arrow-dir: "forward")
      wire((16,15), "6")

      // Ветвь 3 (6 -> 3)
      inductor-better("L3", "6", "3", label: (content: $L_3$, anchor: "west", distance: 1.2), arrow-label: (content: $I_3$, anchor: "east", distance: 1.2), arrow-side: "east")

      // Ветвь 4 (3 -> 1)
      resistor-better("R4", "3", (12,0), label: (content: $R_4$, anchor: "south", distance: 1.2), arrow-label: (content: $I_4$, anchor: "north", distance: 1.2), arrow-side: "north")
      capacitor-better("C4", (12,0), "1", label: (content: $C_4$, anchor: "south", distance: 1.2))
    })
    #v(-0.5cm)
  ]
)

= Расчет токов в ветвях исходной цепи
Находим комплексные сопротивления каждой из ветвей:
#mathtype-mimic[
  $ dot(Z)_1 = R_1 = 55 " Ом"; $
  $ dot(Z)_2 = j X_(L_2) - j X_(C_2) = 66 j - 48 j = 18 j " Ом"; $
  $ dot(Z)_3 = j X_(L_3) = 97 j " Ом"; $
  $ dot(Z)_4 = R_4 - j X_(C_4) = 94 - 98 j " Ом"; $
  $ dot(Z)_5 = j X_(L_5) - j X_(C_5) = 13 j - 53 j = -40 j " Ом"; $
  $ dot(Z)_6 = R_6 + j X_(L_6) = 35 + 68 j " Ом"; $
  $ dot(Z)_7 = R_7 - j X_(C_7) = 16 - 55 j " Ом". $
]

Запишем комплексы независимых источников:
#mathtype-mimic[
  $ dot(E)_5 = 21 e^(j 344 degree) = 20.19 - 5.79 j " В"; $
  $ dot(J)_2 = 1 e^(j 343 degree) = 0.956 - 0.292 j " А". $
]

По методу эквивалентных преобразований преобразуем источник тока $dot(J)_2$ в эквивалентную ЭДС $dot(E)_(J_2)$, направленную так же, как и источник тока (от узла 5 к узлу 6):
#mathtype-mimic[
  $ dot(E)_(J_2) = dot(J)_2 dot dot(Z)_2 = (0.956 - 0.292 j)(18 j) = 5.256 + 17.208 j " В". $
]

Объединим последовательно соединенные элементы. Ветви 5, 6 и 1 образуют эквивалентную ветвь $A$ между узлами 1 и 5:
#mathtype-mimic[
  $ dot(Z)_A = dot(Z)_5 + dot(Z)_6 + dot(Z)_1 = -40 j + 35 + 68 j + 55 = 90 + 28 j " Ом". $
]
Источник $dot(E)_5$ действует вдоль этой ветви от узла 1 к 5, следовательно $dot(E)_A = dot(E)_5$.

Ветви 2, 3 и 4 образуют ветвь $B$ от узла 5 к узлу 1:
#mathtype-mimic[
  $ dot(Z)_B = dot(Z)_2 + dot(Z)_3 + dot(Z)_4 = 18 j + 97 j + 94 - 98 j = 94 + 17 j " Ом". $
]
Эквивалентная ЭДС $dot(E)_(J_2)$ действует вдоль этой ветви от 5 к 1, следовательно $dot(E)_B = dot(E)_(J_2)$.

Ветвь 7 остается неизменной и образует ветвь $C$ между узлами 5 и 1 ($dot(Z)_C = dot(Z)_7$).
Мы получили схему из трех параллельных ветвей, подключенных к узлам 1 и 5 (рисунок 2).

#lab-figure(
  caption: [Схема после объединения ветвей],
  [
    #v(-0.6cm)
    #circuit-better(scale-factor: 85%, {
      import zap: *
      node-better("1", (0, 0), label: (content: "1", anchor: "south", distance: 0.5), visible: true)
      node-better("5", (0, 8), label: (content: "5", anchor: "north", distance: 0.5), visible: true)
      
      // Ветвь A (слева)
      wire("1", (-6, 0))
      source-better("EA", (-6, 0), (-6, 3), label: (content: $E_A$, anchor: "west", distance: 1.2), arrow-dir: "forward")
      resistor-better("ZA", (-6, 3), (-6, 8), label: (content: $Z_A$, anchor: "west", distance: 1.2), arrow-label: (content: $I_A$, anchor: "east", distance: 1.2), arrow-side: "east", arrow-offset: 0.6)
      wire((-6, 8), "5")

      // Ветвь C (по центру)
      resistor-better("ZC", "5", "1", label: (content: $Z_C$, anchor: "west", distance: 1.2), arrow-label: (content: $I_C$, anchor: "east", distance: 1.2), arrow-side: "east", arrow-offset: 0.6)

      // Ветвь B (справа)
      wire("5", (6, 8))
      source-better("EB", (6, 8), (6, 5), label: (content: $E_B$, anchor: "east", distance: 1.2), arrow-dir: "forward")
      resistor-better("ZB", (6, 5), (6, 0), label: (content: $Z_B$, anchor: "east", distance: 1.2), arrow-label: (content: $I_B$, anchor: "west", distance: 1.2), arrow-side: "west", arrow-offset: 0.6)
      wire((6, 0), "1")
    })
    #v(-0.6cm)
  ]
)

Применим метод узловых потенциалов для нахождения напряжения $dot(U)_51$. Примем $phi_1 = 0$:
#mathtype-mimic[
  $ dot(Y)_A = 1 / dot(Z)_A = 1 / (90 + 28 j) = 0.01013 - 0.00315 j " См"; $
  $ dot(Y)_B = 1 / dot(Z)_B = 1 / (94 + 17 j) = 0.01030 - 0.00186 j " См"; $
  $ dot(Y)_C = 1 / dot(Z)_C = 1 / (16 - 55 j) = 0.00488 + 0.01676 j " См". $
]
Потенциал узла 5:
#mathtype-mimic[
  $ phi_5 = (dot(E)_A dot(Y)_A - dot(E)_B dot(Y)_B) / (dot(Y)_A + dot(Y)_B + dot(Y)_C) = \
          = ((20.19 - 5.79 j)(0.01013 - 0.00315 j) - (5.256 + 17.208 j)(0.01030 - 0.00186 j)) / (0.02531 + 0.01175 j) = \
          = (0.1863 - 0.1222 j - 0.0862 - 0.1675 j) / (0.02531 + 0.01175 j) = \
          = (0.1001 - 0.2897 j) / (0.02531 + 0.01175 j) = -1.118 - 10.938 j " В". $
]

Находим токи в эквивалентных ветвях:
#mathtype-mimic[
  $ dot(I)_A = (phi_1 - phi_5 + dot(E)_A) dot(Y)_A = (1.118 + 10.938 j + 20.19 - 5.79 j)(0.01013 - 0.00315 j) = \
             = (21.308 + 5.148 j)(0.01013 - 0.00315 j) = 0.232 - 0.015 j " А"; $
  $ dot(I)_B = (phi_5 - phi_1 + dot(E)_B) dot(Y)_B = (-1.118 - 10.938 j + 5.256 + 17.208 j)(0.01030 - 0.00186 j) = \
             = (4.138 + 6.270 j)(0.01030 - 0.00186 j) = 0.054 + 0.057 j " А"; $
  $ dot(I)_C = (phi_5 - phi_1) dot(Y)_C = (-1.118 - 10.938 j)(0.00488 + 0.01676 j) = 0.178 - 0.072 j " А". $
]
Проверка по 1-му закону Кирхгофа для узла 5 ($dot(I)_A = dot(I)_B + dot(I)_C$):
$0.232 - 0.015 j approx (0.054 + 0.057 j) + (0.178 - 0.072 j)$, расчет верен.

Возвращаемся к исходной схеме и находим реальные токи ветвей. 
Токи в последовательных ветвях равны току эквивалентной ветви:
#mathtype-mimic[
  $ dot(I)_1 = dot(I)_5 = dot(I)_6 = dot(I)_A = 0.232 - 0.015 j = 0.232 e^(-j 3.70 degree) " А"; $
  $ dot(I)_7 = dot(I)_C = 0.178 - 0.072 j = 0.192 e^(-j 22.02 degree) " А"; $
  $ dot(I)_3 = dot(I)_4 = dot(I)_B = 0.054 + 0.057 j = 0.079 e^(j 46.55 degree) " А". $
]

Ток ветви 2 находим по первому закону Кирхгофа для узла 6 ($dot(I)_B = dot(I)_2 + dot(J)_2$):
#mathtype-mimic[
  $ dot(I)_2 = dot(I)_B - dot(J)_2 = (0.054 + 0.057 j) - (0.956 - 0.292 j) = \
             = -0.902 + 0.349 j = 0.967 e^(j 158.83 degree) " А". $
]

По найденным комплексам записываем мгновенные значения токов:
#mathtype-mimic[
  $ i_1(t) = i_5(t) = i_6(t) = sqrt(2) dot 0.232 sin(omega t - 3.70 degree) " А"; $
  $ i_2(t) = sqrt(2) dot 0.967 sin(omega t + 158.83 degree) " А"; $
  $ i_3(t) = i_4(t) = sqrt(2) dot 0.079 sin(omega t + 46.55 degree) " А"; $
  $ i_7(t) = sqrt(2) dot 0.192 sin(omega t - 22.02 degree) " А". $
]

= Составление баланса мощностей
Напряжение на источнике тока $dot(J)_2$ (равно напряжению между узлами 5 и 6):
#mathtype-mimic[
  $ dot(U)_56 = dot(I)_2 dot dot(Z)_2 = (-0.902 + 0.349 j)(18 j) = -6.28 - 16.24 j " В". $
]

Комплексная мощность, отдаваемая источниками:
#mathtype-mimic[
  $ dot(S)_"ист" = dot(E)_5 dot(I)_5^* + dot(U)_56 dot(J)_2^* = \
                 = (20.19 - 5.79 j)(0.232 + 0.015 j) + (-6.28 - 16.24 j)(0.956 + 0.292 j) = \
                 = (4.77 - 1.04 j) + (-1.27 - 17.37 j) = 3.50 - 18.41 j " ВА". $
]
Активная и реактивная мощности источников: $P_"ист" = 3.50 " Вт"$, $Q_"ист" = -18.41 " ВАр"$.

Мощность, рассеиваемая на пассивных элементах цепи:
#mathtype-mimic[
  $ dot(S)_"потр" = |dot(I)_1|^2 dot(Z)_1 + |dot(I)_2|^2 dot(Z)_2 + |dot(I)_3|^2 dot(Z)_3 + |dot(I)_4|^2 dot(Z)_4 + \
                  + |dot(I)_5|^2 dot(Z)_5 + |dot(I)_6|^2 dot(Z)_6 + |dot(I)_7|^2 dot(Z)_7 = \
                  = 0.054(55) + 0.935(18 j) + 0.006(97 j) + 0.006(94 - 98 j) + \
                  + 0.054(-40 j) + 0.054(35 + 68 j) + 0.037(16 - 55 j) = \
                  = 2.97 + 16.83 j + 0.58 j + 0.56 - 0.59 j - 2.16 j + 1.89 + 3.67 j + 0.59 - 2.04 j = \
                  = 3.50 - 18.41 j " ВА". $
]
Как видим, активные и реактивные мощности источника ЭДС, источника тока и сопротивлений оказываются равны ($S_"ист" = S_"потр"$).

= Определяем потенциалы узлов и строим векторную диаграмму
Примем потенциал узла 1 равным нулю ($phi_1 = 0$).
#mathtype-mimic[
  $ phi_5 = -1.12 - 10.94 j " В" "(рассчитано ранее)"; $
  $ phi_6 = phi_5 - dot(I)_2 dot(Z)_2 = -1.12 - 10.94 j - (-6.28 - 16.24 j) = 5.16 + 5.30 j " В"; $
  $ phi_3 = phi_1 + dot(I)_4 dot(Z)_4 = 0 + (0.054 + 0.057 j)(94 - 98 j) = 10.66 + 0.07 j " В"; $
  $ phi_4 = phi_5 - dot(I)_1 dot(Z)_1 = -1.12 - 10.94 j - (0.232 - 0.015 j)(55) = -13.88 - 10.11 j " В"; $
  $ phi_2 = phi_1 + dot(E)_5 - dot(I)_5 dot(Z)_5 = 0 + 20.19 - 5.79 j - (0.232 - 0.015 j)(-40 j) = 20.79 + 3.49 j " В". $
]

= Полагая наличие индуктивной связи между любыми двумя индуктивностями, записать для заданной цепи уравнения по законам Кирхгофа

Предположим наличие магнитной индуктивной связи $M$ между катушками $L_2$ (ветвь 2) и $L_6$ (ветвь 6). Токи входят в одноименные (отмеченные точками) зажимы.

#lab-figure(
  caption: [Схема с учетом магнитной связи между индуктивностями],
  [
    #v(-0.5cm)
    #circuit-better(scale-factor: 70%, {
      import zap: *
      node-better("1", (8, 0), label: (content: "1", anchor: "south", distance: 0.5), visible: true)
      node-better("5", (8, 12), label: (content: "5", anchor: "north-west", distance: 0.8), visible: true)
      node-better("2", (0, 0), label: (content: "2", anchor: "south-west", distance: 0.5), visible: true)
      node-better("4", (0, 12), label: (content: "4", anchor: "north-west", distance: 0.5), visible: true)
      node-better("6", (16, 12), label: (content: "6", anchor: "north-east", distance: 0.5), visible: true)
      node-better("3", (16, 0), label: (content: "3", anchor: "south-east", distance: 0.5), visible: true)

      source-better("E5", "1", (5,0), label: (content: $E_5$, anchor: "south", distance: 1.2), arrow-dir: "forward")
      inductor-better("L5", (2.5,0), (5,0), label: (content: $L_5$, anchor: "south", distance: 1.2)) // изменено направление
      capacitor-better("C5", (2.5,0), "2", label: (content: $C_5$, anchor: "south", distance: 1.2), arrow-label: (content: $I_5$, anchor: "north", distance: 1.2), arrow-side: "north", arrow-dir: "forward")

      resistor-better("R6", "2", (0,6), label: (content: $R_6$, anchor: "east", distance: 1.2), arrow-label: (content: $I_6$, anchor: "west", distance: 1.2), arrow-side: "west")
      inductor-better("L6", (0,6), "4", label: (content: $L_6$, anchor: "east", distance: 1.2))

      resistor-better("R1", "4", "5", label: (content: $R_1$, anchor: "south", distance: 1.2), arrow-label: (content: $I_1$, anchor: "north", distance: 1.2), arrow-side: "north")

      resistor-better("R7", "5", (8,6), label: (content: $R_7$, anchor: "east", distance: 1.2), arrow-label: (content: $I_7$, anchor: "west", distance: 1.2), arrow-side: "west")
      capacitor-better("C7", (8,6), "1", label: (content: $C_7$, anchor: "east", distance: 1.2))

      inductor-better("L2", "5", (12,12), label: (content: $L_2$, anchor: "south", distance: 1.2), arrow-label: (content: $I_2$, anchor: "north", distance: 1.2), arrow-side: "north")
      capacitor-better("C2", (12,12), "6", label: (content: $C_2$, anchor: "south", distance: 1.2))

      wire("5", (8,15))
      jsource-better("J2", (8,15), (16,15), label: (content: $J_2$, anchor: "north", distance: 1.2), arrow-dir: "forward")
      wire((16,15), "6")

      inductor-better("L3", "6", "3", label: (content: $L_3$, anchor: "west", distance: 1.2), arrow-label: (content: $I_3$, anchor: "east", distance: 1.2), arrow-side: "east")

      resistor-better("R4", "3", (12,0), label: (content: $R_4$, anchor: "south", distance: 1.2), arrow-label: (content: $I_4$, anchor: "north", distance: 1.2), arrow-side: "north")
      capacitor-better("C4", (12,0), "1", label: (content: $C_4$, anchor: "south", distance: 1.2))

      // Отрисовка индуктивной связи:
      cetz.draw.circle((0.2, 9), radius: 0.12, fill: black)
      cetz.draw.circle((10, 12.2), radius: 0.12, fill: black)
      cetz.draw.bezier((0.4, 9.2), (9.8, 12.4), (4, 11.5), mark: (start: ">", end: ">", fill: black), stroke: 1pt)
      cetz.draw.content((4, 11), $M$)
    })
    #v(-0.5cm)
  ]
)

Запишем систему уравнений в дифференциальной форме (5 узлов, 2 независимых контура):
#mathtype-mimic[
$ cases(
  i_4 + i_7 - i_5 = 0,
  i_5 - i_6 = 0,
  i_3 - i_4 = 0,
  i_6 - i_1 = 0,
  i_1 - i_2 - i_7 - J_2 = 0,
  L_5 (d i_5)/(d t) + 1/C_5 display(integral) i_5 d t + i_6 R_6 + L_6 (d i_6)/(d t) + M (d i_2)/(d t) + i_1 R_1 + i_7 R_7 + 1/C_7 display(integral) i_7 d t = e_5,
  i_2 R_2 + L_2 (d i_2)/(d t) + M (d i_6)/(d t) + 1/C_2 display(integral) i_2 d t + L_3 (d i_3)/(d t) + i_4 R_4 + 1/C_4 display(integral) i_4 d t - i_7 R_7 - 1/C_7 display(integral) i_7 d t = 0
) $
]

Запишем эти же уравнения в комплексной форме:
#mathtype-mimic[
$ cases(
  dot(I)_4 + dot(I)_7 - dot(I)_5 = 0,
  dot(I)_5 - dot(I)_6 = 0,
  dot(I)_3 - dot(I)_4 = 0,
  dot(I)_6 - dot(I)_1 = 0,
  dot(I)_1 - dot(I)_2 - dot(I)_7 - dot(J)_2 = 0,
  dot(I)_5 (j omega L_5 - j 1/(omega C_5)) + dot(I)_6 (R_6 + j omega L_6) + dot(I)_2 j omega M + dot(I)_1 R_1 + dot(I)_7 (R_7 - j 1/(omega C_7)) = dot(E)_5,
  dot(I)_2 (j omega L_2 - j 1/(omega C_2)) + dot(I)_6 j omega M + dot(I)_3 j omega L_3 + dot(I)_4 (R_4 - j 1/(omega C_4)) - dot(I)_7 (R_7 - j 1/(omega C_7)) = 0
) $
]

= Определяем токи в ветвях исходной схемы методом законов Кирхгофа

Решение систем алгебраических уравнений выполнялось при помощи программы MATHCAD. Решение представлено на рисунке 6.

#figure(
  image("matrix6new_new.png", width: 80%),
  caption: [Расчет токов по законам Кирхгофа]
)

Где X – неизвестные токи, которые находятся путём умножения обратной матрицы A на матрицу B.

= Определяем токи в ветвях исходной схемы методом контурных токов

Решение выполнялось при помощи программы MATHCAD. Результат вычисления представлен на рисунке 7.

#figure(
  image("matrix7new_new.png", width: 80%),
  caption: [Расчет токов методом контурных токов]
)

B – контурная матрица; \
RD = diag(R) – формирование диагональной матрицы RD из матрицы R; \
IK – нахождение контурных токов; \
I – токи ветвей.

= Определяем токи в ветвях исходной схемы методом узловых напряжений

Решение выполнялось при помощи программы MATHCAD. Результат вычисления представлен на рисунке 8.

#figure(
  image("matrix8new_new.png", width: 80%),
  caption: [Расчет токов методом узловых напряжений]
)

A – узловая матрица; \
RD = diag(R) – формирование диагональной матрицы RD из матрицы R; \
G – диагональная матрица G из матрицы RD; \
F – определение потенциалов всех узлов по отношению к базисному узлу; \
U – определение напряжения на всех ветвях цепи; \
IR – определение токов в сопротивлениях ветвей.

= Определение тока в ветви 7 МЭГН

Исключаем ветвь 7 (разрываем цепь между узлами 1 и 5, удаляя сопротивление $Z_7$). На рисунке 9 изображена схема для расчета напряжения холостого хода.

#lab-figure(
  caption: [Схема для расчета напряжения холостого хода],
  [
    #v(-0.6cm)
    #circuit-better(scale-factor: 85%, {
      import zap: *
      node-better("1", (0, 0), label: (content: "1", anchor: "south", distance: 0.5), visible: true)
      node-better("5", (0, 8), label: (content: "5", anchor: "north", distance: 0.5), visible: true)
      
      // Ветвь A (слева)
      wire("1", (-6, 0))
      source-better("EA", (-6, 0), (-6, 3), label: (content: $E_A$, anchor: "west", distance: 1.2), arrow-dir: "forward")
      resistor-better("ZA", (-6, 3), (-6, 8), label: (content: $Z_A$, anchor: "west", distance: 1.2), arrow-label: (content: $I_"A,xx"$, anchor: "east", distance: 1.2), arrow-side: "east", arrow-offset: 0.6)
      wire((-6, 8), "5")

      // Разрыв вместо ветви C
      open-branch-better("Uxx", "5", "1", label: (content: $dot(U)_"хх"$, anchor: "west", distance: 1.5), arrow-side: "west", arrow-dir: "forward", show-terminals: true, arrow-offset: 0.6)

      // Ветвь B (справа)
      wire("5", (6, 8))
      source-better("EB", (6, 8), (6, 5), label: (content: $E_B$, anchor: "east", distance: 1.2), arrow-dir: "forward")
      resistor-better("ZB", (6, 5), (6, 0), label: (content: $Z_B$, anchor: "east", distance: 1.2), arrow-label: (content: $I_"B,xx"$, anchor: "west", distance: 1.2), arrow-side: "west", arrow-offset: 0.6)
      wire((6, 0), "1")
    })
    #v(-0.6cm)
  ]
)

Напряжение холостого хода $dot(U)_"хх"$ (напряжение между узлами 5 и 1). Рассчитаем по методу двух узлов:
#mathtype-mimic[
  $ dot(Y)_"AB" = dot(Y)_A + dot(Y)_B = (0.01013 - 0.00315 j) + (0.01030 - 0.00186 j) = 0.02043 - 0.00501 j " См"; $
  $ dot(U)_"хх" = phi_5^"хх" - phi_1 = (dot(E)_A dot(Y)_A - dot(E)_B dot(Y)_B) / dot(Y)_"AB" = \
                = (0.1001 - 0.2897 j) / (0.02043 - 0.00501 j) = 7.89 - 12.24 j " В". $
]

Закоротив источники ЭДС и разомкнув источники тока, находим эквивалентное сопротивление схемы относительно зажимов 5-1:

#mathtype-mimic[
  $ dot(Z)_"экв" = 1 / dot(Y)_"AB" = 1 / (0.02043 - 0.00501 j) = 46.16 + 11.32 j " Ом". $
]

Подключаем ветвь 7 к эквивалентному генератору и находим ток $dot(I)_7$:

#lab-figure(
  caption: [Эквивалентная схема МЭГН],
  [
    #v(-0.4cm)
    #circuit-better(scale-factor: 85%, {
      import zap: *
      node-better("5", (0, 6), label: (content: "5", anchor: "north", distance: 0.5), visible: true)
      node-better("1", (0, 0), label: (content: "1", anchor: "south", distance: 0.5), visible: true)
      
      wire("5", (-6, 6))
      source-better("Eeq", (-6, 6), (-6, 3), label: (content: $dot(U)_"хх"$, anchor: "west", distance: 1.2), arrow-dir: "forward")
      resistor-better("Zeq", (-6, 3), (-6, 0), label: (content: $Z_"экв"$, anchor: "west", distance: 1.2))
      wire((-6, 0), "1")

      resistor-better("R7", "5", (0,3), label: (content: $R_7$, anchor: "east", distance: 1.2), arrow-label: (content: $I_7$, anchor: "west", distance: 1.2), arrow-side: "west", arrow-offset: 0.6)
      capacitor-better("C7", (0,3), "1", label: (content: $C_7$, anchor: "east", distance: 1.2))
    })
    #v(-0.4cm)
  ]
)

#mathtype-mimic[
  $ dot(I)_7 = dot(U)_"хх" / (dot(Z)_"экв" + dot(Z)_7) = \
             = (7.89 - 12.24 j) / (46.16 + 11.32 j + 16 - 55 j) = \
             = (7.89 - 12.24 j) / (62.16 - 43.68 j) = \
             = 0.178 - 0.072 j " А". $
]
Ток полностью совпадает с рассчитанным ранее.

= Таблица ответов

#figure(
  caption: none,
  table(
    columns: (auto, auto, auto, auto, auto),
    align: center + horizon,
    table.header(
      table.cell(rowspan: 2)[Параметр],
      table.cell(colspan: 2)[Алгебраическая форма],
      table.cell(colspan: 2)[Показательная форма],
      [Re], [Im], [Модуль], [Арг., $degree$]
    ),
    [$I_1$], [0.232], [-0.015], [0.232], [-3.70],
    [$I_5$], [0.232], [-0.015], [0.232], [-3.70],
    [$I_6$], [0.232], [-0.015], [0.232], [-3.70],
    [$I_2$], [-0.902], [0.349], [0.967], [158.83],
    [$I_3$], [0.054], [0.057], [0.079], [46.55],
    [$I_4$], [0.054], [0.057], [0.079], [46.55],
    [$I_7$], [0.178], [-0.072], [0.192], [-22.02],
    [Мощность $S_"ист"$], [3.50], [-18.41], [18.74], [-79.24],
    [Мощность $S_"потр"$], [3.50], [-18.41], [18.74], [-79.24],
    [$U_"хх"$], [7.89], [-12.24], [14.56], [-57.19],
    [$Z_"ген"$], [46.16], [11.32], [47.53], [13.78]
  )
)