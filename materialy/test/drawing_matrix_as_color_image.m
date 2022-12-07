%experiment vykresleni matice jako obrazek s ruznymi barvami
%dale vykreslovani tvarů křížek a tečka do obrázku
%dale schovani souradnicovych os
%dale reset obrazku na modrou barvu
%dale vykresleni mrizek mezi polickami obrazku

rgbMatrix = zeros(2, 2, 3);

rgbMatrix(1,1, 1:3) = [1 0 0];
rgbMatrix(1,2, 1:3) = [0 1 0];
rgbMatrix(2,1, 1:3) = [1 0 1];
rgbMatrix(2,2, 1:3) = [0 0 1];

x1 = 0.5;
y1 = 0.5;
fig = figure();
img = image(x1, y1, rgbMatrix);

fig_axes = get(fig, "CurrentAxes");
set(fig_axes, 'XColor', 'none', 'YColor', 'none');

line([1 1], [2 0], 'Color', 'black', 'LineWidth', 5.5);
line([0 2], [1 1], 'Color', 'black', 'LineWidth', 5.5);

x=[1 2];
y=[1 0];
line(x, y, 'Color', 'black', 'LineWidth', 2.5);
line(x, [0 1], 'Color', 'black', 'LineWidth', 2.5);

rectangle('Position', [0.25 1.3 0.5 0.5], 'Curvature', [1 1], 'FaceColor', 'r');
rectangle('Position', [1.25 1.3 0.5 0.5], 'Curvature', [1 1], 'FaceColor', 'r');

rgbMatrix(1, 1:2, 1:3) = [0 0 1; 0 0 1];
rgbMatrix(2, 1:2, 1:3) = [0 0 1; 0 0 1];
img.CData = rgbMatrix;





