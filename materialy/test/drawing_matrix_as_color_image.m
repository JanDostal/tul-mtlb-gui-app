%experiment vykresleni matice jako obrazek s ruznymi barvami
% vykresleni popisků sloupců a řádků
%dale vykreslovani tvarů křížek a tečka do obrázku
%dale reset obrazku na modrou barvu
%dale vykresleni mrizek mezi polickami obrazku

rgbMatrix = zeros(2, 2, 3);

rgbMatrix(1,1, 1:3) = [1 0 0];
rgbMatrix(1,2, 1:3) = [0 1 0];
rgbMatrix(2,1, 1:3) = [1 0 1];
rgbMatrix(2,2, 1:3) = [0 0 1];

x1 = 1;
y1 = 1;
fig = figure();
img = image(x1, y1, rgbMatrix);

fig_axes = get(fig, "CurrentAxes");
yticklabels(["", "A", "", "B"]);
xticklabels(["", "1", "", "2"]);
set(fig_axes, 'LineWidth', 5.5);

line([1.5 1.5], [0.5 2.5], 'Color', 'black', 'LineWidth', 5.5);
line([0.5 2.5], [1.5 1.5], 'Color', 'black', 'LineWidth', 5.5);

line([1.5 2.5], [1.5 0.5], 'Color', 'black', 'LineWidth', 2.5);
line([1.5 2.5], [0.5 1.5], 'Color', 'black', 'LineWidth', 2.5);

rectangle('Position', [0.75 0.8 0.5 0.5], 'Curvature', [1 1], 'FaceColor', 'r');
rectangle('Position', [0.75 1.8 0.5 0.5], 'Curvature', [1 1], 'FaceColor', 'r');

rgbMatrix(1, 1:2, 1:3) = [0 0 1; 0 0 1];
rgbMatrix(2, 1:2, 1:3) = [0 0 1; 0 0 1];
img.CData = rgbMatrix;





