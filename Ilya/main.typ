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
    variant: "558302-3",
  ),
  manager: (
    name: "Батюков С.В.",
  ),
  performer: (
    name: "Бежок И.Д.",
    group: "558302",
  ),
  footer: (city: "Минск", year: 2026),
  city: none,
  year: none,
  add-pagebreaks: false,
  text-size: 14pt,
)

#show: apply-toec-styling

// Отключаем нумерацию страниц
#set page(footer: none)

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
    [1], [36], [0],  [93], [18], [0],  [0],  [9], [319],
    [2], [64], [94], [0],  [69], [0],  [0],  [0], [0],
    [3], [41], [44], [0],  [67], [0],  [0],  [0], [0],
    [4], [15], [0],  [57], [0],  [0],  [0],  [0], [0],
    [5], [52], [0],  [72], [0],  [0],  [0],  [0], [0],
    [6], [23], [16], [0],  [78], [0],  [0],  [0], [0],
    [7], [65], [0],  [96], [0],  [71], [44], [0], [0],
  )
)

Найти токи по методу эквивалентных преобразований. Составить баланс мощностей. Построить векторную диаграмму токов и напряжений. Найти ток в ветви 3 МЭГН.

На рисунке 1 изображена исходная схема.

#lab-figure(
  caption: [Исходная схема],
  [
    #v(-0.5cm)
    #circuit-better(scale-factor: 70%, {
      import zap: *
      node-better("6", (10, 16), label: (content: "6", anchor: "north", distance: 0.5), visible: true)
      node-better("5", (10, 0), label: (content: "5", anchor: "south", distance: 0.5), visible: true)
      node-better("4", (20, 11), label: (content: "4", anchor: "west", distance: 0.5), visible: true)
      node-better("1", (20, 5), label: (content: "1", anchor: "west", distance: 0.5), visible: true)
      node-better("3", (0, 11), label: (content: "3", anchor: "east", distance: 0.5), visible: true)
      node-better("2", (0, 5), label: (content: "2", anchor: "east", distance: 0.5), visible: true)

      // Ветви пути A (Правая часть)
      wire("6", (20, 16))
      wire((20, 16), (20, 14.5))
      resistor-better("R2", (20, 14.5), (20, 12.5), label: (content: $R_2$, anchor: "west", distance: 0.8), arrow-label: $I_2$, arrow-side: "east", arrow-dir: "forward")
      capacitor-better("C2", (20, 12.5), "4", label: (content: $C_2$, anchor: "west", distance: 0.8))
      
      resistor-better("R3", "4", (20, 7), label: (content: $R_3$, anchor: "west", distance: 0.8), arrow-label: $I_3$, arrow-side: "east", arrow-dir: "forward")
      capacitor-better("C3", (20, 7), "1", label: (content: $C_3$, anchor: "west", distance: 0.8))
      
      inductor-better("L4", "1", (20, 1.5), label: (content: $L_4$, anchor: "west", distance: 0.8), arrow-label: $I_4$, arrow-side: "east", arrow-dir: "forward")
      wire((20, 1.5), (20, 0))
      wire((20, 0), "5")

      // Ветви пути C (Левая часть)
      wire("5", (0, 0))
      wire((0, 0), (0, 1.5))
      inductor-better("L5", (0, 1.5), "2", label: (content: $L_5$, anchor: "east", distance: 0.8), arrow-label: $I_5$, arrow-side: "west", arrow-dir: "forward")
      
      resistor-better("R6", "2", (0, 8.5), label: (content: $R_6$, anchor: "east", distance: 0.8), arrow-label: $I_6$, arrow-side: "west", arrow-dir: "forward")
      capacitor-better("C6", (0, 8.5), "3", label: (content: $C_6$, anchor: "east", distance: 0.8))
      
      inductor-better("L1", "3", (0, 14.5), label: (content: $L_1$, anchor: "east", distance: 0.8), arrow-label: $I_1$, arrow-side: "west", arrow-dir: "forward")
      capacitor-better("C1", (0, 14.5), (0, 16), label: (content: $C_1$, anchor: "east", distance: 0.8))
      wire((0, 16), "6")

      // Источник тока J1
      wire("3", (-4, 11))
      wire((-4, 11), (-4, 12))
      jsource-better("J1", (-4, 12), (-4, 15), label: (content: $J_1$, anchor: "east", distance: 1.0), arrow-dir: "forward")
      wire((-4, 15), (-4, 16))
      wire((-4, 16), (0, 16))

      // Ветвь пути B (Центральная часть)
      source-better("E7", "6", (10, 10), label: (content: $E_7$, anchor: "east", distance: 1.0), arrow-dir: "forward")
      inductor-better("L7", (10, 10), "5", label: (content: $L_7$, anchor: "east", distance: 0.8), arrow-label: $I_7$, arrow-side: "west", arrow-dir: "forward")
    })
    #v(-0.5cm)
  ]
)

= Расчет токов в ветвях исходной цепи
Находим комплексные сопротивления каждой из ветвей:
#mathtype-mimic[
  $ dot(Z)_1 = j X_(L_1) - j X_(C_1) = 93 j - 18 j = 75 j " Ом"; $
  $ dot(Z)_2 = R_2 - j X_(C_2) = 94 - 69 j " Ом"; $
  $ dot(Z)_3 = R_3 - j X_(C_3) = 44 - 67 j " Ом"; $
  $ dot(Z)_4 = j X_(L_4) = 57 j " Ом"; $
  $ dot(Z)_5 = j X_(L_5) = 72 j " Ом"; $
  $ dot(Z)_6 = R_6 - j X_(C_6) = 16 - 78 j " Ом"; $
  $ dot(Z)_7 = j X_(L_7) = 96 j " Ом". $
]

Запишем комплексы независимых источников:
#mathtype-mimic[
  $ dot(E)_7 = 71 e^(j 44 degree) = 51.07 + 49.32 j " В"; $
  $ dot(J)_1 = 9 e^(j 319 degree) = 6.79 - 5.90 j " А". $
]

По методу эквивалентных преобразований преобразуем источник тока $dot(J)_1$ в эквивалентную ЭДС $dot(E)_(J_1)$, направленную так же, как и источник тока (от узла 3 к узлу 6):
#mathtype-mimic[
  $ dot(E)_(J_1) = dot(J)_1 dot dot(Z)_1 = (6.79 - 5.90 j)(75 j) = 442.82 + 509.43 j " В". $
]

Объединим последовательно соединенные элементы. Ветви 2, 3 и 4 образуют эквивалентную ветвь $A$ (ток направлен от узла 6 к узлу 5):
#mathtype-mimic[
  $ dot(Z)_A = dot(Z)_2 + dot(Z)_3 + dot(Z)_4 = \
             = 94 - 69 j + 44 - 67 j + 57 j = 138 - 79 j " Ом". $
]

Ветвь 7 образует ветвь $B$ ($dot(Z)_B = dot(Z)_7$) между узлами 6 и 5. Ток направлен от 6 к 5, ЭДС также направлена от 6 к 5.
Ветви 5, 6 и 1 соединены последовательно и образуют эквивалентную ветвь $C$. Направление выберем от узла 6 к узлу 5:
#mathtype-mimic[
  $ dot(Z)_C = dot(Z)_1 + dot(Z)_6 + dot(Z)_5 = 75 j + 16 - 78 j + 72 j = 16 + 69 j " Ом". $
]

Найдем эквивалентные проводимости ветвей:
#mathtype-mimic[
  $ dot(Y)_A = 1 / dot(Z)_A = 1 / (138 - 79 j) = 0.00546 + 0.00312 j " См"; $
  $ dot(Y)_B = 1 / dot(Z)_B = 1 / (96 j) = -0.01042 j " См"; $
  $ dot(Y)_C = 1 / dot(Z)_C = 1 / (16 + 69 j) = 0.00319 - 0.01375 j " См". $
]

По методу двух узлов найдем узловое напряжение $dot(U)_65$ (примем $phi_5 = 0$). ЭДС $E_7$ направлена от узла 6, поэтому берется со знаком минус. Эквивалентная ЭДС $E_(J_1)$ ветви $C$ направлена к узлу 6, поэтому берется со знаком плюс:
#mathtype-mimic[
  $ dot(U)_65 = (-dot(E)_7 dot(Y)_B + dot(E)_(J_1) dot(Y)_C) / (dot(Y)_A + dot(Y)_B + dot(Y)_C) = \
              = ( -(51.07 + 49.32 j)(-0.01042 j) + \
              + (442.82 + 509.43 j)(0.00319 - 0.01375 j) ) / (0.00865 - 0.02105 j) = \
              = (-0.51 + 0.53 j + 8.42 - 4.47 j) / (0.00865 - 0.02105 j) = \
              = (7.91 - 3.94 j) / (0.00865 - 0.02105 j) = \
              = 291.85 + 255.54 j " В". $
]

Определяем токи в параллельных эквивалентных ветвях (от узла 6 к узлу 5):
#mathtype-mimic[
  $ dot(I)_A = (dot(U)_65) dot(Y)_A = \
             = (291.85 + 255.54 j)(0.00546 + 0.00312 j) = \
             = 0.79 + 2.31 j " А"; $
  $ dot(I)_B = (dot(U)_65 + dot(E)_7) dot(Y)_B = \
             = (291.85 + 255.54 j + 51.07 + 49.32 j)(-0.01042 j) = \
             = 3.18 - 3.57 j " А"; $
  $ dot(I)'_C = (dot(U)_65 - dot(E)_(J_1)) dot(Y)_C = \
              = (291.85 + 255.54 j - 442.82 - 509.43 j)(0.00319 - 0.01375 j) = \
              = -3.97 + 1.27 j " А". $
]

По найденным токам ветвей находим истинные токи исходной схемы:
#mathtype-mimic[
  $ dot(I)_2 = dot(I)_3 = dot(I)_4 = dot(I)_A = 0.79 + 2.31 j " А"; $
  $ dot(I)_7 = dot(I)_B = 3.18 - 3.57 j " А". $
]
Ток контура $C$, направленный от 5 к 6, равен $dot(I)_"конт" = -dot(I)'_C = 3.97 - 1.27 j " А"$. Следовательно:
#mathtype-mimic[
  $ dot(I)_5 = dot(I)_6 = dot(I)_"конт" = 3.97 - 1.27 j " А". $
]
Истинный ток 1-й ветви (через элемент $dot(Z)_1$) по первому закону Кирхгофа:
#mathtype-mimic[
  $ dot(I)_1 = dot(I)_"конт" - dot(J)_1 = \
             = (3.97 - 1.27 j) - (6.79 - 5.90 j) = \
             = -2.82 + 4.64 j " А". $
]

= Составление баланса мощностей
Напряжение на ветви 1 (падение напряжения от узла 3 к узлу 6):
#mathtype-mimic[
  $ dot(U)_36 = dot(I)_1 dot dot(Z)_1 = (-2.82 + 4.64 j)(75 j) = -347.78 - 211.43 j " В". $
]

Комплексная мощность, отдаваемая источниками (ток $J_1$ направлен от 3 к 6, мощность вычисляется как $-dot(U)_36 dot(J)_1^*$ с учетом несовпадения направления тока и потенциала):
#mathtype-mimic[
  $ dot(S)_"ист" = dot(E)_7 dot(I)_7^* - dot(U)_36 dot(J)_1^* = \
                 = (51.07 + 49.32 j)(3.18 + 3.57 j) - \
                 - (-347.78 - 211.43 j)(6.79 + 5.90 j) = \
                 = (-14.00 + 339.06 j) - (-1114.00 - 3489.47 j) = \
                 = 1100.00 + 3828.53 j " ВА". $
]
Активная мощность источника: $P_"ист" = 1100.00 " Вт"$, Реактивная мощность: $Q_"ист" = 3828.53 " ВАр"$.

Мощность, потребляемая пассивными элементами цепи:
#mathtype-mimic[
  $ dot(S)_"потр" = |dot(I)_A|^2 dot(Z)_A + |dot(I)_7|^2 dot(Z)_B + \
                  + |dot(I)_"конт"|^2 (dot(Z)_5 + dot(Z)_6) + |dot(I)_1|^2 dot(Z)_1 = \
                  = 5.95 (138 - 79 j) + 22.85 (96 j) + \
                  + 17.39 (16 - 6 j) + 29.45 (75 j) = \
                  = 821.32 - 470.18 j + 2193.12 j + \
                  + 278.29 - 104.36 j + 2208.75 j = \
                  = 1099.61 + 3827.33 j " ВА". $
]
Погрешность расчетов минимальна. Баланс мощностей сошелся.

= Определяем потенциалы узлов и рисуем векторную диаграмму
#lab-figure(
  caption: [Векторная диаграмма токов и напряжений],
  image("diagram.png", width: 80%) // Заглушка, положите ваш файл diagram.png в папку
)

= Полагая наличие индуктивной связи между индуктивностями $L_4$ и $L_5$, записать уравнения по законам Кирхгофа

Запишем систему уравнений в дифференциальной форме для независимых контуров и узлов (с учетом взаимной индуктивности $M$):
#mathtype-mimic[
$ cases(
  i_4 - i_5 - i_7 = 0,
  i_1 - i_2 - i_7 + J_1 = 0,
  i_5 - i_6 = 0,
  i_6 - i_1 - J_1 = 0,
  i_2 - i_3 = 0,
  i_2 R_2 + 1/C_2 display(integral) i_2 d t + i_3 R_3 + \
  1/C_3 display(integral) i_3 d t + L_4 (d i_4)/(d t) - \
  M (d i_5)/(d t) - L_7 (d i_7)/(d t) = -e_7,
  L_7 (d i_7)/(d t) - L_5 (d i_5)/(d t) + M (d i_4)/(d t) - \
  i_6 R_6 - 1/C_6 display(integral) i_6 d t - \
  L_1 (d i_1)/(d t) - 1/C_1 display(integral) i_1 d t = e_7
) $
]

В комплексной форме эти же уравнения принимают вид:
#mathtype-mimic[
$ cases(
  dot(I)_4 - dot(I)_5 - dot(I)_7 = 0,
  dot(I)_1 - dot(I)_2 - dot(I)_7 + dot(J)_1 = 0,
  dot(I)_5 - dot(I)_6 = 0,
  dot(I)_6 - dot(I)_1 - dot(J)_1 = 0,
  dot(I)_2 - dot(I)_3 = 0,
  dot(I)_2 (R_2 - j 1/(omega C_2)) + dot(I)_3 (R_3 - j 1/(omega C_3)) + \
  dot(I)_4 j omega L_4 - dot(I)_5 j omega M - dot(I)_7 j omega L_7 = -dot(E)_7,
  dot(I)_7 j omega L_7 - dot(I)_5 j omega L_5 + dot(I)_4 j omega M - \
  dot(I)_6 (R_6 - j 1/(omega C_6)) - \
  dot(I)_1 (j omega L_1 - j 1/(omega C_1)) = dot(E)_7
) $
]

= Определяем токи в ветвях исходной схемы методом законов Кирхгофа

Решение систем алгебраических уравнений выполнялось при помощи программы MATHCAD. Решение представлено на рисунке 2.

// #figure(
//   image("matrix6new_new.png", width: 80%), // Заглушка, положите ваш файл matrix6new_new.png в папку
//   caption: [Расчет токов по законам Кирхгофа]
// )

Где X – неизвестные токи, которые находятся путём умножения обратной матрицы A на матрицу B.

= Определяем токи в ветвях исходной схемы методом контурных токов

Решение выполнялось при помощи программы MATHCAD. Результат вычисления представлен на рисунке 3.

// #figure(
//   image("matrix7new_new.png", width: 80%), // Заглушка, положите ваш файл matrix7new_new.png в папку
//   caption: [Расчет токов методом контурных токов]
// )

B – контурная матрица; \
RD = diag(R) – формирование диагональной матрицы RD из матрицы R; \
IK – нахождение контурных токов; \
I – токи ветвей.

= Определяем токи в ветвях исходной схемы методом узловых напряжений

Решение выполнялось при помощи программы MATHCAD. Результат вычисления представлен на рисунке 4.

// #figure(
//   image("matrix8new_new.png", width: 80%), // Заглушка, положите ваш файл matrix8new_new.png в папку
//   caption: [Расчет токов методом узловых напряжений]
// )

A – узловая матрица; \
RD = diag(R) – формирование диагональной матрицы RD из матрицы R; \
G – диагональная матрица G из матрицы RD; \
F – определение потенциалов всех узлов по отношению к базисному узлу; \
U – определение напряжения на всех ветвях цепи; \
IR – определение токов в сопротивлениях ветвей.

= Определение тока в ветви 3 МЭГН
Исключаем ветвь сопротивления 3 (разрываем цепь между узлами 4 и 1, удаляя только исследуемое сопротивление $Z_3$). Ток ветви 2 становится равным нулю ($dot(I)_2 = 0$), так как цепь разомкнута. Следовательно, потенциал узла 4 становится равен потенциалу узла 6 ($phi_4 = phi_6$). Аналогично $dot(I)_4 = 0$, поэтому потенциал узла 1 равен потенциалу узла 5 ($phi_1 = phi_5$). Напряжение холостого хода $dot(U)_"хх"$ (напряжение между 4 и 1) будет в точности равно узловому напряжению $dot(U)_65_"хх"$.

#lab-figure(
  caption: [Схема для расчета напряжения холостого хода],
  [
    #v(-0.5cm)
    #circuit-better(scale-factor: 70%, {
      import zap: *
      node-better("6", (10, 16), label: (content: "6", anchor: "north", distance: 0.5), visible: true)
      node-better("5", (10, 0), label: (content: "5", anchor: "south", distance: 0.5), visible: true)
      node-better("4", (20, 11), label: (content: "4", anchor: "west", distance: 0.5), visible: true)
      node-better("1", (20, 5), label: (content: "1", anchor: "west", distance: 0.5), visible: true)
      
      // Правая часть (ветви 2, xx, 4)
      wire("6", (20, 16))
      wire((20, 16), (20, 14.5))
      resistor-better("Z2", (20, 14.5), "4", label: (content: $Z_2$, anchor: "west", distance: 0.8), arrow-label: $I_2=0$, arrow-side: "east", arrow-dir: "forward")
      
      open-branch-better("Uxx", "4", "1", label: $dot(U)_"хх"$, arrow-side: "west", arrow-dir: "forward", show-terminals: true)
      
      resistor-better("Z4", "1", (20, 1.5), label: (content: $Z_4$, anchor: "west", distance: 0.8), arrow-label: $I_4=0$, arrow-side: "east", arrow-dir: "forward")
      wire((20, 1.5), (20, 0))
      wire((20, 0), "5")

      // Центральная часть (Ветвь B)
      source-better("E7", "6", (10, 10), label: (content: $E_7$, anchor: "east", distance: 1.0), arrow-dir: "forward")
      resistor-better("Z7", (10, 10), "5", label: (content: $Z_7$, anchor: "east", distance: 0.8))

      // Левая часть (Ветвь C и экв. ЭДС)
      wire("6", (0, 16))
      wire((0, 16), (0, 12))
      source-better("EC", (0, 12), (0, 8), label: (content: $E_C$, anchor: "west", distance: 1.0), arrow-dir: "forward")
      resistor-better("ZC", (0, 8), (0, 2), label: (content: $Z_C$, anchor: "west", distance: 0.8), arrow-label: $I'_C$, arrow-side: "east", arrow-dir: "forward")
      wire((0, 2), (0, 0))
      wire((0, 0), "5")
    })
    #v(-0.5cm)
  ]
)

Рассчитаем $dot(U)_"хх"$ для оставшейся части цепи (ветви B и C):
#mathtype-mimic[
  $ dot(U)_"хх" = dot(U)_65_"хх" = (-dot(E)_7 dot(Y)_B + dot(E)_(J_1) dot(Y)_C) / (dot(Y)_B + dot(Y)_C) = \
                = (7.91 - 3.94 j) / (-0.01042 j + 0.00319 - 0.01375 j) = \
                = (7.91 - 3.94 j) / (0.00319 - 0.02417 j) = \
                = 202.37 + 300.31 j " В". $
]

Закоротив источники ЭДС и разомкнув источники тока, находим эквивалентное сопротивление схемы относительно зажимов 4-1. Для этого схема сворачивается, и эквивалентное сопротивление рассчитывается как параллельное соединение ветвей B и C плюс последовательные ветви 2 и 4:
#mathtype-mimic[
  $ dot(Z)_"экв" = dot(Z)_2 + dot(Z)_4 + (dot(Z)_B dot dot(Z)_C) / (dot(Z)_B + dot(Z)_C) = \
                 = (94 - 69 j) + 57 j + 1 / (0.00319 - 0.02417 j) = \
                 = 94 - 12 j + 5.37 + 40.66 j = \
                 = 99.37 + 28.66 j " Ом". $
]

#lab-figure(
  caption: [Эквивалентная схема МЭГН],
  [
    #v(-0.4cm)
    #circuit-better(scale-factor: 85%, {
      import zap: *
      node-better("4", (12, 6), label: (content: "4", anchor: "east", distance: 0.5), visible: true)
      node-better("1", (0, 6), label: (content: "1", anchor: "west", distance: 0.5), visible: true)
      
      wire("4", (12, 2))
      source-better("Eeq", (12, 2), (6, 2), label: (content: $dot(U)_"хх"$, anchor: "south", distance: 1.2), arrow-dir: "backward")
      resistor-better("Zeq", (6, 2), (0, 2), label: (content: $Z_"экв"$, anchor: "south", distance: 0.5))
      wire((0, 2), "1")

      resistor-better("Z3", "1", "4", label: (content: $Z_3$, anchor: "south", distance: 0.5), arrow-label: $I_3$, arrow-side: "north", arrow-offset: 0.4, arrow-dir: "backward")
    })
    #v(-0.4cm)
  ]
)

Подключаем ветвь 3 к эквивалентному генератору (рисунок 6) и находим ток $dot(I)_3$:
#mathtype-mimic[
  $ dot(I)_3 = dot(U)_"хх" / (dot(Z)_"экв" + dot(Z)_3) = \
             = (202.37 + 300.31 j) / (99.37 + 28.66 j + 44 - 67 j) = \
             = (202.37 + 300.31 j) / (143.37 - 38.34 j) = \
             = 0.79 + 2.31 j " А". $
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
    [$I_1$], [-2.82], [4.64], [5.43], [121.30],
    [$I_2$], [0.79], [2.31], [2.44], [71.10],
    [$I_3$], [0.79], [2.31], [2.44], [71.10],
    [$I_4$], [0.79], [2.31], [2.44], [71.10],
    [$I_5$], [3.97], [-1.27], [4.17], [-17.70],
    [$I_6$], [3.97], [-1.27], [4.17], [-17.70],
    [$I_7$], [3.18], [-3.57], [4.78], [-48.30],
    [Мощность $S_"ист"$], [1100.00], [3828.53], [3983.30], [73.97],
    [Мощность $S_"потр"$], [1099.61], [3827.33], [3982.20], [73.97],
    [$U_"хх"$], [202.37], [300.31], [362.10], [56.02],
    [$Z_"экв"$], [99.37], [28.66], [103.42], [16.09]
  )
)