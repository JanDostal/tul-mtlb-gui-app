classdef DataManager < handle

    properties (Constant)

        WATER_COLOR = [0 0 1]; ... %graficka reprezentace vody na desce s lodemi
        BLACK_COLOR = [0 0 0]; ... %graficka reprezentace krizku a tecek na barevne desce s lodemi
        WATER_ID = uint32(0); ... % defaultni id pro prazdny prostor na desce s lodemi
        PLAYER_ID = uint32(1); % id hrace v databazi
        ENEMY_ID = uint32(2); % id nepritele v databazi
        GAME_BOARD_ROWS_ALPHABET = 'A':'Z';

        ShipTypeColorsEnum = ShipTypeColorsEnum;
        ErrorTypesEnum = ErrorTypesEnum;
        ShipHealthStatusEnum = ShipHealthStatusEnum;
        ShipShootStatusEnum = ShipShootStatusEnum;
    end

    properties

        Database;

        PlayerBoard; % deska s id lodi hrace
        EnemyBoard; % deska id lodi nepritele
        PlayerColorBoard; % graficke znazorneni desky s id lodi hrace
        EnemyShipsHitsColorBoard; % graficke znazorneni zasahu a minuti nepratelskych lodi
        
        EnemyShootingCoordinatesMemory; % ukladani pozic desky hrace, na ktere uz nepritel strilel
        PlayerShootingCoordinatesMemory; % ukladani pozic desky nepritele, na ktere uz hrac strilel
        PlayerBoardShipsAdditionOrder; % ukladani id lodi v poradi, v jakem byly pridany na desku hrace
    end

    methods

        function instance = DataManager()

            ShipTypeColorsEnum = DataManager.ShipTypeColorsEnum;

            createSeededDatabase();

            function createSeededDatabase()
            
                instance.Database = struct( ...
                                         "shipTypes", ...
                                             [
                                                 struct( ...
                                                        "id", uint32(1), ...
                                                        "name", "Ponorka", ...
                                                        "color", ShipTypeColorsEnum.Red, ... % pro zobrazeni lode na graficke desce
                                                        "shape", uint32(zeros(1, 1)) ... % urcuje tvar lode
                                                       );
                              
                                                 struct( ...
                                                        "id", uint32(2), ...
                                                        "name", "Torpédoborec", ...
                                                        "color", ShipTypeColorsEnum.Green, ...
                                                        "shape", uint32(zeros(1, 2)) ...
                                                       );

                                                 struct( ...
                                                        "id", uint32(3), ...
                                                        "name", "Křižník", ...
                                                        "color", ShipTypeColorsEnum.Magenta, ...
                                                        "shape", uint32(zeros(1, 3)) ...
                                                       );

                                                 struct( ...
                                                        "id", uint32(4), ...
                                                        "name", "Bitevní loď", ...
                                                        "color", ShipTypeColorsEnum.Yellow, ...
                                                        "shape", uint32(zeros(1, 4)) ...
                                                       );

                                                 struct( ...
                                                        "id", uint32(5), ...
                                                        "name", "Letadlová loď", ...
                                                        "color", ShipTypeColorsEnum.Orange, ...
                                                        "shape", uint32(zeros(1, 5)) ...
                                                       )
                                             ], ...
                                         "ships", ...
                                             [
                                                 struct( ...
                                                        "id", uint32(1), ...
                                                        "coordinates", double.empty(0, 2), ... % sada souradnic, delka sady podle tvaru lode
                                                        "health", logical.empty(0, 1), ... % sada logickych 0 a 1, delka sady podle tvaru lode
                                                        "ownerId", DataManager.PLAYER_ID, ...
                                                        "shipTypeId", uint32(1) ...
                                                       );

                                                 struct( ...
                                                        "id", uint32(2), ...
                                                        "coordinates", double.empty(0, 2), ...
                                                        "health", logical.empty(0, 1), ...
                                                        "ownerId", DataManager.PLAYER_ID, ...
                                                        "shipTypeId", uint32(1) ...
                                                       );

                                                 struct( ...
                                                        "id", uint32(3), ...
                                                        "coordinates", double.empty(0, 2), ...
                                                        "health", logical.empty(0, 1), ...
                                                        "ownerId", DataManager.PLAYER_ID, ...
                                                        "shipTypeId", uint32(2) ...
                                                       );

                                                 struct( ...
                                                        "id", uint32(4), ...
                                                        "coordinates", double.empty(0, 2), ...
                                                        "health", logical.empty(0, 1), ...
                                                        "ownerId", DataManager.PLAYER_ID, ...
                                                        "shipTypeId", uint32(2) ...
                                                       );

                                                 struct( ...
                                                        "id", uint32(5), ...
                                                        "coordinates", double.empty(0, 2), ...
                                                        "health", logical.empty(0, 1), ...
                                                        "ownerId", DataManager.PLAYER_ID, ...
                                                        "shipTypeId", uint32(3) ...
                                                       );

                                                 struct( ...
                                                        "id", uint32(6), ...
                                                        "coordinates", double.empty(0, 2), ...
                                                        "health", logical.empty(0, 1), ...
                                                        "ownerId", DataManager.PLAYER_ID, ...
                                                        "shipTypeId", uint32(4) ...
                                                       );

                                                 struct( ...
                                                        "id", uint32(7), ...
                                                        "coordinates", double.empty(0, 2), ...
                                                        "health", logical.empty(0, 1), ...
                                                        "ownerId", DataManager.PLAYER_ID, ...
                                                        "shipTypeId", uint32(5) ...
                                                       );

                                                 struct( ...
                                                        "id", uint32(8), ...
                                                        "coordinates", double.empty(0, 2), ...
                                                        "health", logical.empty(0, 1), ...
                                                        "ownerId", DataManager.ENEMY_ID, ...
                                                        "shipTypeId", uint32(1) ...
                                                       );

                                                 struct( ...
                                                        "id", uint32(9), ...
                                                        "coordinates", double.empty(0, 2), ...
                                                        "health", logical.empty(0, 1), ...
                                                        "ownerId", DataManager.ENEMY_ID, ...
                                                        "shipTypeId", uint32(1) ...
                                                       );

                                                 struct( ...
                                                        "id", uint32(10), ...
                                                        "coordinates", double.empty(0, 2), ...
                                                        "health", logical.empty(0, 1), ...
                                                        "ownerId", DataManager.ENEMY_ID, ...
                                                        "shipTypeId", uint32(2) ...
                                                       );

                                                 struct( ...
                                                        "id", uint32(11), ...
                                                        "coordinates", double.empty(0, 2), ...
                                                        "health", logical.empty(0, 1), ...
                                                        "ownerId", DataManager.ENEMY_ID, ...
                                                        "shipTypeId", uint32(2) ...
                                                  );

                                                 struct( ...
                                                        "id", uint32(12), ...
                                                        "coordinates", double.empty(0, 2), ...
                                                        "health", logical.empty(0, 1), ...
                                                        "ownerId", DataManager.ENEMY_ID, ...
                                                        "shipTypeId", uint32(3) ...
                                                       );

                                                 struct( ...
                                                        "id", uint32(13), ...
                                                        "coordinates", double.empty(0, 2), ...
                                                        "health", logical.empty(0, 1), ...
                                                        "ownerId", DataManager.ENEMY_ID, ...
                                                        "shipTypeId", uint32(4) ...
                                                       );

                                                 struct( ...
                                                        "id", uint32(14), ...
                                                        "coordinates", double.empty(0, 2), ...
                                                        "health", logical.empty(0, 1), ...
                                                        "ownerId", DataManager.ENEMY_ID, ...
                                                        "shipTypeId", uint32(5) ...
                                                       )
                                             ], ...
                                         "players", ...
                                             [
                                                 struct( ...
                                                        "id", DataManager.PLAYER_ID, ...
                                                        "name", "Hráč" ...
                                                       );

                                                 struct( ...
                                                        "id", DataManager.ENEMY_ID, ...
                                                        "name", "Nepřítel" ...
                                                       )
                                             ]...
                                          );

            end
        end
    end

    methods (Access = private)
        
        function resetPlayerBoardShipsAdditionOrder(this)

            this.PlayerBoardShipsAdditionOrder = uint32.empty(1, 0);
        end

        function [selectedRows, selectedColumns] = calculateGameBoardIndexingArea(~, ...
                selectedRow, selectedColumn, direction, matrix)
            
            dimensionsCount = length(size(matrix));

            if dimensionsCount == 3
            
                matrix = matrix(:, :, 1);
            end

            matrixHeight = size(matrix, 1);
            matrixWidth = size(matrix, 2);

            switch direction
                
                case ShipOrientationsEnum.Upwards

                    lastRow = selectedRow - (matrixHeight - 1);
                    selectedRows = selectedRow:-1:lastRow;
                    
                    lastColumn = selectedColumn + (matrixWidth - 1);
                    selectedColumns = selectedColumn:1:lastColumn;

                case ShipOrientationsEnum.Downwards
                   
                    lastRow = selectedRow + (matrixHeight - 1);
                    selectedRows = selectedRow:1:lastRow;
                    
                    lastColumn = selectedColumn + (matrixWidth - 1);
                    selectedColumns = selectedColumn:1:lastColumn;

                case ShipOrientationsEnum.Left

                    lastRow = selectedRow + (matrixHeight - 1);
                    selectedRows = selectedRow:-1:lastRow;
                    
                    lastColumn = selectedColumn - (matrixWidth - 1);
                    selectedColumns = selectedColumn:-1:lastColumn;

                case ShipOrientationsEnum.Right

                    lastRow = selectedRow + (matrixHeight - 1);
                    selectedRows = selectedRow:-1:lastRow;
                    
                    lastColumn = selectedColumn + (matrixWidth - 1);
                    selectedColumns = selectedColumn:1:lastColumn;
            end                     
        end

        function rgbMatrix = createRgbMatrixFromGivenColor(~, width, height, color)
            
            rgbMatrix(1:height, 1:width, 1) = color(1);
            rgbMatrix(1:height, 1:width, 2) = color(2);
            rgbMatrix(1:height, 1:width, 3) = color(3);
        end

        function sortedDatabaseTable = sortDatabaseTable(~, databaseTable)

            [~, sortIndeces] = sort([databaseTable.id]);
            sortedDatabaseTable = databaseTable(sortIndeces);
        end

        function [placementRows, placementColumns] = loadPlacementCoordinates(~, shipCoordinates)

            rowCoordinates = shipCoordinates(:, 1);
            rowCoordinates = rowCoordinates.';

            columnCoordinates = shipCoordinates(:, 2);
            columnCoordinates = columnCoordinates.';
                
            placementRows = unique(rowCoordinates);
            placementColumns = unique(columnCoordinates);
        end

        function [chosenShip, chosenShipType] = loadShipAndShipType(this, playerId, shipTypeId, gameBoard)
            
            chosenShip = loadShip();
            chosenShipType = loadShipType();

            function chosenShip = loadShip()

                shipsTable = this.Database.ships;

                playerShips = shipsTable([shipsTable.ownerId] == playerId);
                playerShipsByShipType = playerShips([playerShips.shipTypeId] == shipTypeId);
                [logicalMask, ~] = ismember([playerShipsByShipType.id], gameBoard);
                notPositionedPlayerShipsByShipType = playerShipsByShipType(not(logicalMask));

                chosenShip = notPositionedPlayerShipsByShipType(1);
            end

            function chosenShipType = loadShipType()
                
                shipsTypesTable = this.Database.shipTypes;

                chosenShipType = shipsTypesTable([shipsTypesTable.id] == shipTypeId);
            end
        end

        function isShipPlacementAreaOccupied = checkIfShipPlacementAreaIsOccupied(~, playerBoard, selectedRows, selectedColumns)
                    
            shipPlacementArea = playerBoard(selectedRows, selectedColumns);
            isShipPlacementAreaOccupied = any(shipPlacementArea, "all");
        end

        function isShipTouchingWithAnother = checkIfThereAreSurroundingShips(~, playerBoard, selectedRows, selectedColumns)
                    
            [rowTouchingAreas, colTouchingAreas] = loadSurroundingAreasIndeces();

            selectedRows = [selectedRows rowTouchingAreas];
            selectedColumns = [selectedColumns colTouchingAreas];
                
            shipPlacementSurroundingsArea = playerBoard(selectedRows, selectedColumns);
            isShipTouchingWithAnother = any(shipPlacementSurroundingsArea, "all");

            function [rowTouchingAreas, colTouchingAreas] = loadSurroundingAreasIndeces()

                playerBoardFirstRow = 1;
                playerBoardLastRow = size(playerBoard, 1);
                playerBoardFirstColumn = 1;
                playerBoardLastColumn = size(playerBoard, 2);

                ascendedSortedSelectedRows = sort(selectedRows);
                ascendedSortedSelectedColumns = sort(selectedColumns);

                firstSelectedRow = ascendedSortedSelectedRows(1);
                firstSelectedColumn = ascendedSortedSelectedColumns(1);
                lastSelectedRow = ascendedSortedSelectedRows(end);
                lastSelectedColumn = ascendedSortedSelectedColumns(end);

                rowTouchingAreas = [];
                colTouchingAreas = [];

                if firstSelectedRow ~= playerBoardFirstRow
                    
                    rowTouchingAreas = [rowTouchingAreas firstSelectedRow - 1];
                end

                if lastSelectedColumn ~= playerBoardLastColumn
                    
                    colTouchingAreas = [colTouchingAreas lastSelectedColumn + 1];
                end

                if firstSelectedColumn ~= playerBoardFirstColumn

                    colTouchingAreas = [colTouchingAreas firstSelectedColumn - 1];
                end

                if lastSelectedRow ~= playerBoardLastRow
                    
                    rowTouchingAreas = [rowTouchingAreas lastSelectedRow + 1];
                end
            end
        end

        function shipCoordinates = updateShipInDatabase(this, ...
                    gameBoardRow, gameBoardColumn, shipOrientation, ...
                    shipShape, chosenShipId)

            shipCoordinates = calculateShipCoordinates();
            coordinatesCount = size(shipCoordinates, 1);
            shipHealth = calculateShipHealth();

            shipsTable = this.Database.ships;

            this.Database.ships([shipsTable.id] == chosenShipId).coordinates = shipCoordinates;
            this.Database.ships([shipsTable.id] == chosenShipId).health = shipHealth;

            function shipHealth = calculateShipHealth()

                shipHealth = true(coordinatesCount, 1);
            end

            function shipCoordinates = calculateShipCoordinates()

                [selectedRows, selectedColumns] = this.calculateGameBoardIndexingArea( ...
                gameBoardRow, gameBoardColumn, shipOrientation, shipShape);

                selectedRows = selectedRows.';
                originalSelectedRows = selectedRows;
                selectedColumns = selectedColumns.';

                selectedRows = repmat(selectedRows, length(selectedColumns), 1);
                selectedColumns = repmat(selectedColumns, length(originalSelectedRows), 1);
                
                shipCoordinates = [selectedRows selectedColumns];
            end
        end

        function wasHitRepeated = checkIfHitIsRepeated(~, playerMemory, gameboardRow, gameBoardColumn)
                
            if isempty(playerMemory) == true

                wasHitRepeated = false;
                return;
            end
                
            [wasHitRepeated, ~] = ismember([gameboardRow gameBoardColumn], ...
                playerMemory, "rows");
        end

        function shootedShip = loadShootedShip(this, playerId, shipId)
                
            shipsTable = this.Database.ships;

            playerShips = shipsTable([shipsTable.ownerId] == playerId);
            shootedShip = playerShips([playerShips.id] == shipId);
        end

        function [wasShipHit, wasShipSunken] = setShootStatusWaterHit(~)
                
            wasShipHit = false;
            wasShipSunken = false;
        end

        function [shipPartHealthStatus, coordinatesLocation]  = loadShipPartHealthStatus(~, gameBoardRow, gameBoardColumn, shootedShip)
                
            [~, coordinatesLocation] = ismember([gameBoardRow gameBoardColumn], ...
            shootedShip.coordinates, "rows");

            shipPartHealthStatus = shootedShip.health(coordinatesLocation);
        end

        function updatedHealth = decreaseShootedShipHealth(this, shootedShip, coordinatesLocation)

            shootedShip.health(coordinatesLocation) = DataManager.ShipHealthStatusEnum.Hit;
            shipsTable = this.Database.ships;
            this.Database.ships([shipsTable.id] == shootedShip.id).health = shootedShip.health;
            updatedHealth = shootedShip.health;
        end

        function shipShootStatus = loadShipShootStatus(~, wasShipHit, wasShipSunken, wasHitRepeated)
                
            if wasShipHit == false && wasShipSunken == false && wasHitRepeated == false
                    
                shipShootStatus = DataManager.ShipShootStatusEnum.WaterHit;

            elseif wasShipHit == false && wasShipSunken == false && wasHitRepeated == true
                    
                shipShootStatus = DataManager.ShipShootStatusEnum.WaterHitRepeatedly;

            elseif wasShipHit == true && wasShipSunken == false && wasHitRepeated == false

                shipShootStatus = DataManager.ShipShootStatusEnum.ShipHit;

            elseif wasShipHit == true && wasShipSunken == false && wasHitRepeated == true

                shipShootStatus = DataManager.ShipShootStatusEnum.ShipHitRepeatedly;

            elseif wasShipHit == true && wasShipSunken == true && wasHitRepeated == false

                shipShootStatus = DataManager.ShipShootStatusEnum.ShipSunk;
            end
        end
    end

    methods (Access = public)

        function areAllEnemyShipsSunken = checkIfPlayerWon(this, playerId)
            
            shipsTable = this.Database.ships;
            shipTypesTable = this.Database.shipTypes;

            sortedShipTypes = this.sortDatabaseTable(shipTypesTable);
            shipTypesIds = [sortedShipTypes.id];
            
            playerShips = shipsTable([shipsTable.ownerId] == playerId);
            totalHealth = arrayfun(@(shipTypeId)  all(not([playerShips([playerShips.shipTypeId] == ...
                shipTypeId).health]), "all"), shipTypesIds);

            areAllEnemyShipsSunken = all(totalHealth);
        end

        function position = loadCirclePosition(~, chosenColorBoard, gameBoardRow, gameBoardColumn)

            gameBoardWidth = size(chosenColorBoard.CData, 2);
            gameBoardHeight = size(chosenColorBoard.CData, 1);

            lastElementCenterXLocation = chosenColorBoard.XData(2);
            firstElementCenterXLocation = chosenColorBoard.XData(1);

            lastElementCenterYLocation = chosenColorBoard.YData(2);
            firstElementCenterYLocation = chosenColorBoard.YData(1);

            elementHeight = (lastElementCenterYLocation - firstElementCenterYLocation) / ...
                (gameBoardHeight - 1);

            elementWidth = (lastElementCenterXLocation - firstElementCenterXLocation) / ...
                (gameBoardWidth - 1);

            [width, height] = loadDimensions();
            [x, y] = loadLowestLeftCornerCoordinates();

            position = [x y width height];

            function [width, height] = loadDimensions()
                
                height = elementHeight - elementHeight / 2;
                width = elementWidth - elementWidth / 2;
            end

            function [x, y] = loadLowestLeftCornerCoordinates()
               
                selectedElementCenterXLocation = firstElementCenterXLocation + (gameBoardColumn - 1) * elementWidth;
                selectedElementCenterYLocation = firstElementCenterYLocation + (gameBoardRow - 1) * elementHeight;

                y = selectedElementCenterYLocation - height / 2;
                x = selectedElementCenterXLocation - width / 2;
            end
        end

        function [X, Y] = loadGameColorBoardCrossCoordinates(~, chosenColorBoard, gameBoardRow, gameBoardColumn)

            gameBoardWidth = size(chosenColorBoard.CData, 2);
            gameBoardHeight = size(chosenColorBoard.CData, 1);

            X = loadXCoordinates();
            Y = loadYCoordinates();

            function X = loadXCoordinates()
                
                lastElementCenterXLocation = chosenColorBoard.XData(2);
                firstElementCenterXLocation = chosenColorBoard.XData(1);

                elementWidth = (lastElementCenterXLocation - firstElementCenterXLocation) / ...
                    (gameBoardWidth - 1);
                firstTickValue = firstElementCenterXLocation - elementWidth / 2;

                firstCoordinate = firstTickValue + elementWidth * (gameBoardColumn - 1);
                secondCoordinate = firstCoordinate + elementWidth;

                X = [firstCoordinate firstCoordinate;
                     secondCoordinate secondCoordinate];
            end

            function Y = loadYCoordinates()
                
                lastElementCenterYLocation = chosenColorBoard.YData(2);
                firstElementCenterYLocation = chosenColorBoard.YData(1);

                elementHeight = (lastElementCenterYLocation - firstElementCenterYLocation) / ...
                    (gameBoardHeight - 1);
                firstTickValue = firstElementCenterYLocation - elementHeight / 2;

                firstCoordinate = firstTickValue + elementHeight * (gameBoardRow - 1);
                secondCoordinate = firstCoordinate + elementHeight;

                Y = [firstCoordinate secondCoordinate;
                     secondCoordinate firstCoordinate];
            end       
        end

        function shipShootStatus = fireOnEnemyBoard(this, ...
                gameBoardRow, gameBoardColumn)
            
            wasHitRepeated = this.checkIfHitIsRepeated(this.PlayerShootingCoordinatesMemory, ...
                gameBoardRow, gameBoardColumn);

            if wasHitRepeated == false
                    
                addShipCoordinatesToMemory();
            end

            shipId = this.EnemyBoard(gameBoardRow, gameBoardColumn);

            if (shipId == DataManager.WATER_ID)
                
                [wasShipHit, wasShipSunken] = this.setShootStatusWaterHit();

            else
                
                shootedShip = this.loadShootedShip(DataManager.ENEMY_ID, shipId);
                [shipPartHealthStatus, coordinatesLocation]  = this.loadShipPartHealthStatus(gameBoardRow, gameBoardColumn, shootedShip);

                if shipPartHealthStatus == DataManager.ShipHealthStatusEnum.NotHit
                    
                    updatedHealth = this.decreaseShootedShipHealth(shootedShip, coordinatesLocation);
                    wasShipHit = true;

                    wasShipSunken = all(not(updatedHealth));

                    if wasShipSunken == true
                        
                        updateEnemyShipsHitsColorBoard();
                    end

                else
                    
                    [wasShipSunken, wasShipHit] = setShootStatusShipHitRepeatedly();
                end
            end

            shipShootStatus = this.loadShipShootStatus(wasShipHit, wasShipSunken, wasHitRepeated);

            function updateEnemyShipsHitsColorBoard()

                [placementRows, placementColumns] = this.loadPlacementCoordinates(shootedShip.coordinates);
                shipColor = loadShootedShipColor();

                placementMatrixHeight = length(placementRows);
                placementMatrixWidth = length(placementColumns);

                shipColorRepresentation = this.createRgbMatrixFromGivenColor(placementMatrixWidth, ...
                    placementMatrixHeight, shipColor);

                this.EnemyShipsHitsColorBoard.CData(placementRows, placementColumns, 1:3) = ...
                    shipColorRepresentation;
            end

            function [wasShipSunken, wasShipHit] = setShootStatusShipHitRepeatedly()

                wasShipSunken = false;
                wasShipHit = true;
            end

            function addShipCoordinatesToMemory()
                
                currentMemory = this.PlayerShootingCoordinatesMemory;
                this.PlayerShootingCoordinatesMemory = [currentMemory; gameBoardRow gameBoardColumn];
            end

            function shipColor = loadShootedShipColor()
                
                shipTypesTable = this.Database.shipTypes;

                shootedShipShipType = shipTypesTable([shipTypesTable.id] == shootedShip.shipTypeId);
                shipColor = shootedShipShipType.color;
            end
        end

        function [shipShootStatus, gameBoardRow, gameBoardColumn] = fireOnPlayerBoard(this)
            
            wasHitRepeated = true;

            while wasHitRepeated == true

                [gameBoardRow, gameBoardColumn] = generateInputCoordinates();

                wasHitRepeated = this.checkIfHitIsRepeated(this.EnemyShootingCoordinatesMemory, ...
                    gameBoardRow, gameBoardColumn);
            end
 
            addShipCoordinatesToMemory();

            shipId = this.PlayerBoard(gameBoardRow, gameBoardColumn);

            if (shipId == DataManager.WATER_ID)
                
                [wasShipHit, wasShipSunken] = this.setShootStatusWaterHit();

            else
                
                shootedShip = this.loadShootedShip(DataManager.PLAYER_ID, shipId);
                [~, coordinatesLocation] = ...
                    this.loadShipPartHealthStatus(gameBoardRow, gameBoardColumn, shootedShip);
                updatedHealth = this.decreaseShootedShipHealth(shootedShip, coordinatesLocation);

                wasShipHit = true;
                wasShipSunken = all(not(updatedHealth));
            end

            shipShootStatus = this.loadShipShootStatus(wasShipHit, wasShipSunken, wasHitRepeated);

            function [gameBoardRow, gameBoardColumn] = generateInputCoordinates()
                
                gameBoardHeight = size(this.PlayerBoard, 1);
                gameBoardWidth = size(this.PlayerBoard, 2);
                
                gameBoardRow = randi([1 gameBoardHeight]);
                gameBoardColumn = randi([1 gameBoardWidth]);
            end

            function addShipCoordinatesToMemory()
                
                currentMemory = this.EnemyShootingCoordinatesMemory;
                this.EnemyShootingCoordinatesMemory = [currentMemory; gameBoardRow gameBoardColumn];
            end
        end

        function addShipsOnEnemyGameBoard(this)
            
            areThereAnyUnpositionedShips = true;

            while areThereAnyUnpositionedShips == true
                
                isValid = false;

                while isValid == false
                    
                    [shipTypeId, isValid] = tryGenerateShipTypeId();
                end

                [chosenShip, chosenShipType] = this.loadShipAndShipType(DataManager.ENEMY_ID, ...
                    shipTypeId, this.EnemyBoard);
                shipShape = chosenShipType.shape;
                
                errorOccured = true;

                while errorOccured == true

                    [shipOrientation, gameBoardRow, gameBoardColumn] = generateOtherInputValues();
                    shipShape = chosenShipType.shape;

                    if shipOrientation == ShipOrientationsEnum.Upwards.getValue() ...
                        || shipOrientation == ShipOrientationsEnum.Downwards.getValue()
                    
                        shipShape = shipShape.';
                    end

                    errorOccured = checkIfPositionedShipIsOutOfBounds();

                    if (errorOccured == true)

                        continue;
                    end

                    errorOccured = checkIfPositionedShipIsCollidingWithAnother();
                end
            
                shipCoordinates = this.updateShipInDatabase(gameBoardRow, ...
                    gameBoardColumn, shipOrientation, ...
                        shipShape, chosenShip.id);

                addShipOnGameBoard();

                areThereAnyUnpositionedShips = this.checkAllRemainingUnpositionedShips(DataManager.ENEMY_ID, ...
                    this.EnemyBoard);
            end

            function [shipTypeId, isValid] = tryGenerateShipTypeId()
                
                shipTypesIds = loadShipTypesIds();
                shipTypesIdsCount = length(shipTypesIds);

                randomShipTypeIdPosition = randi([1 shipTypesIdsCount]);
                shipTypeId = shipTypesIds(randomShipTypeIdPosition);

                isValid = this.checkRemainingUnpositionedShipsByShipType( ...
                    shipTypeId, this.ENEMY_ID, this.EnemyBoard);

                function shipTypesIds = loadShipTypesIds()

                    shipTypesTable = this.Database.shipTypes;
                    sortedShipTypes = this.sortDatabaseTable(shipTypesTable);

                    shipTypesIds = [sortedShipTypes.id];
                end
            end

            function [shipOrientation, gameBoardRow, gameBoardColumn] = generateOtherInputValues()
                
                gameBoardHeight = size(this.EnemyBoard, 1);
                gameBoardWidth = size(this.EnemyBoard, 2);
                
                gameBoardRow = randi([1 gameBoardHeight]);
                gameBoardColumn = randi([1 gameBoardWidth]);

                [enumValues, ~] = enumeration('ShipOrientationsEnum');
                enumValues = enumValues.getValue();
                enumValuePosition = randi([1 length(enumValues)]);
                shipOrientation = enumValues(enumValuePosition);
            end

            function addShipOnGameBoard()
                
                [placementRows, placementColumns] = this.loadPlacementCoordinates(shipCoordinates);
                placementMatrix = loadPlacementMatrixWithShipId();

                this.EnemyBoard(placementRows, placementColumns) = placementMatrix;

                function placementMatrix = loadPlacementMatrixWithShipId()
                    
                    placementMatrix = shipShape;
                    placementMatrix(:) = chosenShip.id;
                end
            end
            
            function errorOccured = checkIfPositionedShipIsCollidingWithAnother()
                
                errorOccured = false;

                [selectedRows, selectedColumns] = this.calculateGameBoardIndexingArea(gameBoardRow, ...
                    gameBoardColumn, shipOrientation, shipShape);

                isShipPlacementAreaOccupied = this.checkIfShipPlacementAreaIsOccupied(this.EnemyBoard, selectedRows, selectedColumns);

                if isShipPlacementAreaOccupied == true

                    errorOccured = true;
                    return;
                end

                isShipTouchingWithAnother = this.checkIfThereAreSurroundingShips(this.EnemyBoard, selectedRows, selectedColumns);

                if isShipTouchingWithAnother == true

                    errorOccured = true;
                end
            end

            function errorOccured = checkIfPositionedShipIsOutOfBounds()
                    
                shipSize = length(chosenShipType.shape);
                playerBoardLastRow = size(this.EnemyBoard, 1);
                playerBoardLastColumn = size(this.EnemyBoard, 2);
                errorOccured = false;

                switch shipOrientation

                    case ShipOrientationsEnum.Upwards.getValue()

                        shipEndPosition = gameBoardRow - shipSize;

                    case ShipOrientationsEnum.Downwards.getValue()
                        
                        shipEndPosition = gameBoardRow + (shipSize - 1);

                    case ShipOrientationsEnum.Left.getValue()

                        shipEndPosition = gameBoardColumn - shipSize;

                    case ShipOrientationsEnum.Right.getValue()

                        shipEndPosition = gameBoardColumn + (shipSize - 1);
                end

                if shipEndPosition < 0 || shipEndPosition > playerBoardLastColumn || ...
                    shipEndPosition > playerBoardLastRow
                    
                    errorOccured = true;
                end
            end
        end

        function removeAllAddedShips(this)
            
            playerBoardWidth = size(this.PlayerBoard, 2);
            playerBoardHeight = size(this.PlayerBoard, 1);

            removeAllShipsFromGameBoard();
            removeAllShipsFromGameColorBoard();
            updatePlayerShipsInDatabase();
            this.resetPlayerBoardShipsAdditionOrder();

            function updatePlayerShipsInDatabase()

                shipsTable = this.Database.ships;
                playerShips = shipsTable([shipsTable.ownerId] == DataManager.PLAYER_ID);
                enemyShips = shipsTable([shipsTable.ownerId] == DataManager.ENEMY_ID);

                [playerShips.coordinates] = deal(double.empty(0, 2));
                [playerShips.health] = deal(logical.empty(0, 1));

                shipsTable = [playerShips; enemyShips];
                shipsTable = this.sortDatabaseTable(shipsTable);
                this.Database.ships = shipsTable;
            end

            function removeAllShipsFromGameBoard()
                
                this.PlayerBoard(1:playerBoardHeight, 1:playerBoardWidth) = ...
                    uint32(zeros(playerBoardHeight, playerBoardWidth));
            end

            function removeAllShipsFromGameColorBoard()
                
                blueRgbMatrix = this.createRgbMatrixFromGivenColor(playerBoardWidth, playerBoardHeight, ...
                    DataManager.WATER_COLOR);
                this.PlayerColorBoard.CData(1:playerBoardHeight, 1:playerBoardWidth, 1:3) = blueRgbMatrix;
            end
        end

        function [shipsCountByShipTypeAsString, removedShipShipTypeId] = removeLastAddedShip(this)

            lastAddedShip = loadLastAddedShip();

            [placementRows, placementColumns] = this.loadPlacementCoordinates(lastAddedShip.coordinates);
            
            shipShapeWidth = length(placementColumns);
            shipShapeHeight = length(placementRows);
            
            removeAddedShipFromGameBoard();
            removeAddedShipFromGameColorBoard();
            [shipsCountByShipTypeAsString, removedShipShipTypeId] = this.loadShipsListBoxUpdatedValues();
            updateShipInDatabase();
            removeShipFromPlayerBoardShipsAdditionOrder();

            function updateShipInDatabase()

                shipsTable = this.Database.ships;

                this.Database.ships([shipsTable.id] == lastAddedShip.id).coordinates = double.empty(0, 2);
                this.Database.ships([shipsTable.id] == lastAddedShip.id).health = logical.empty(0, 1);
            end

            function removeAddedShipFromGameBoard()
                
                this.PlayerBoard(placementRows, placementColumns) = ...
                    uint32(zeros(shipShapeHeight, shipShapeWidth));
            end

            function removeAddedShipFromGameColorBoard()
                
                blueRgbMatrix = this.createRgbMatrixFromGivenColor(shipShapeWidth, shipShapeHeight, ...
                    DataManager.WATER_COLOR);
                this.PlayerColorBoard.CData(placementRows, placementColumns, 1:3) = blueRgbMatrix;
            end

            function removeShipFromPlayerBoardShipsAdditionOrder()

                this.PlayerBoardShipsAdditionOrder = this.PlayerBoardShipsAdditionOrder(1:end-1);
            end

            function lastAddedShip = loadLastAddedShip()
                    
                lastAddedShipId = this.PlayerBoardShipsAdditionOrder(end);
                
                shipsTable = this.Database.ships;

                playerShips = shipsTable([shipsTable.ownerId] == DataManager.PLAYER_ID);
                lastAddedShip = playerShips([playerShips.id] == lastAddedShipId);
            end
        end

        function [errorType] = tryAddShipOnPlayerGameBoard(this, ...
                shipOrientation, gameBoardRow, gameBoardColumn, shipTypeId)
            
            [chosenShip, chosenShipType] = this.loadShipAndShipType(DataManager.PLAYER_ID, ...
                shipTypeId, this.PlayerBoard);

            shipShape = chosenShipType.shape;

            if shipOrientation == ShipOrientationsEnum.Upwards.getValue() ...
                || shipOrientation == ShipOrientationsEnum.Downwards.getValue()
                    
                shipShape = shipShape.';
            end

            errorType = checkIfPositionedShipIsOutOfBounds();

            if (errorType ~= DataManager.ErrorTypesEnum.None)

                return;
            end

            errorType = checkIfPositionedShipIsCollidingWithAnother();

            if (errorType ~= DataManager.ErrorTypesEnum.None)

                return;
            end
            
            shipCoordinates = this.updateShipInDatabase(gameBoardRow, ...
                gameBoardColumn, shipOrientation, ...
                    shipShape, chosenShip.id);

            [placementRows, placementColumns] = addShipOnGameBoard();

            addShipOnGameColorBoard();

            addShipToPlayerBoardShipsAdditionOrder();

            function [placementRows, placementColumns] = addShipOnGameBoard()
                
                [placementRows, placementColumns] = this.loadPlacementCoordinates(shipCoordinates);
                placementMatrix = loadPlacementMatrixWithShipId();

                this.PlayerBoard(placementRows, placementColumns) = placementMatrix;

                function placementMatrix = loadPlacementMatrixWithShipId()
                    
                    placementMatrix = shipShape;
                    placementMatrix(:) = chosenShip.id;
                end
            end

            function addShipOnGameColorBoard()
                
                placementMatrixHeight = size(shipShape, 1);
                placementMatrixWidth = size(shipShape, 2);

                shipColorRepresentation = this.createRgbMatrixFromGivenColor(placementMatrixWidth, ...
                    placementMatrixHeight, chosenShipType.color);

                this.PlayerColorBoard.CData(placementRows, placementColumns, 1:3) = ...
                    shipColorRepresentation;
            end

            function addShipToPlayerBoardShipsAdditionOrder()
                
                currentAdditionOrder = this.PlayerBoardShipsAdditionOrder;

                this.PlayerBoardShipsAdditionOrder = [currentAdditionOrder chosenShip.id];
            end
            
            function errorType = checkIfPositionedShipIsCollidingWithAnother()
                
                errorType = DataManager.ErrorTypesEnum.None;

                [selectedRows, selectedColumns] = this.calculateGameBoardIndexingArea(gameBoardRow, ...
                    gameBoardColumn, shipOrientation, shipShape);

                isShipPlacementAreaOccupied = this.checkIfShipPlacementAreaIsOccupied(this.PlayerBoard, selectedRows, selectedColumns);

                if isShipPlacementAreaOccupied == true

                    errorType = DataManager.ErrorTypesEnum.CollidedOccupied;
                    return;
                end

                isShipTouchingWithAnother = this.checkIfThereAreSurroundingShips(this.PlayerBoard, selectedRows, selectedColumns);

                if isShipTouchingWithAnother == true

                    errorType = DataManager.ErrorTypesEnum.CollidedTouching;
                end
            end

            function errorType = checkIfPositionedShipIsOutOfBounds()
                    
                shipSize = length(chosenShipType.shape);
                playerBoardLastRow = size(this.PlayerBoard, 1);
                playerBoardLastColumn = size(this.PlayerBoard, 2);
                errorType = DataManager.ErrorTypesEnum.None;

                switch shipOrientation

                    case ShipOrientationsEnum.Upwards.getValue()

                        shipEndRowPosition = gameBoardRow - shipSize;

                        if shipEndRowPosition < 0

                            errorType = DataManager.ErrorTypesEnum.OutOfBoundsUpwards;
                        end

                    case ShipOrientationsEnum.Downwards.getValue()
                        
                        shipEndRowPosition = gameBoardRow + (shipSize - 1);

                        if shipEndRowPosition > playerBoardLastRow
                        
                            errorType = DataManager.ErrorTypesEnum.OutOfBoundsDownwards;
                        end

                    case ShipOrientationsEnum.Left.getValue()

                        shipEndColumnPosition = gameBoardColumn - shipSize;

                        if shipEndColumnPosition < 0
                            
                            errorType = DataManager.ErrorTypesEnum.OutOfBoundsLeft;
                        end

                    case ShipOrientationsEnum.Right.getValue()

                        shipEndColumnPosition = gameBoardColumn + (shipSize - 1);

                        if shipEndColumnPosition > playerBoardLastColumn
                            
                            errorType = DataManager.ErrorTypesEnum.OutOfBoundsRight;
                        end
                end
            end
        end
        
        function areThereAnyUnpositionedShipsOfThisShipType = checkRemainingUnpositionedShipsByShipType(this, ...
                shipTypeId, playerId, gameBoard)

            shipsTable = this.Database.ships;

            playerShips = shipsTable([shipsTable.ownerId] == playerId);
            playerShipsByShipType = playerShips([playerShips.shipTypeId] == shipTypeId);
            [logicalMask, ~] = ismember([playerShipsByShipType.id], gameBoard);
            
            areThereAnyUnpositionedShipsOfThisShipType = any(not(logicalMask), "all");
        end

        function areThereAnyUnpositionedShips = checkAllRemainingUnpositionedShips(this, playerId, gameBoard)

            shipsTable = this.Database.ships;

            playerShips = shipsTable([shipsTable.ownerId] == playerId);
            [logicalMask, ~] = ismember([playerShips.id], gameBoard);
            
            areThereAnyUnpositionedShips = any(not(logicalMask), "all");
        end

        function areAllShipsUnpositioned = checkAllAlreadyPositionedShips(this)

            shipsTable = this.Database.ships;

            playerShips = shipsTable([shipsTable.ownerId] == DataManager.PLAYER_ID);
            [logicalMask, ~] = ismember([playerShips.id], this.PlayerBoard);
            
            areAllShipsUnpositioned = all(not(logicalMask), "all");
        end

        function shipTypesNames = loadShipTypesNames(this)

            shipTypesTable = this.Database.shipTypes;
            sortedShipTypes = this.sortDatabaseTable(shipTypesTable);

            shipTypesNames = [sortedShipTypes.name];
        end

        function shipTypesColors = loadShipTypesColors(this)

            shipTypesTable = this.Database.shipTypes;
            sortedShipTypes = this.sortDatabaseTable(shipTypesTable);

            shipTypesColors = [sortedShipTypes.color];
            shipTypesColors = reshape(shipTypesColors, length(DataManager.WATER_COLOR), ...
                length(sortedShipTypes));
            shipTypesColors = shipTypesColors.';
        end

        function [gameBoardRowsLetters, gameBoardColumnsNumbers] = generateChosenGameBoardLabels(~, chosenBoard)
            
            gameBoardRowsLetters = generateGameBoardRowsLetters();
            gameBoardColumnsNumbers = generateGameBoardColumnsNumbers();

            function gameBoardRowsLetters = generateGameBoardRowsLetters()

                gameBoardHeight = size(chosenBoard, 1);
                lettersList = DataManager.GAME_BOARD_ROWS_ALPHABET(1:gameBoardHeight);
                gameBoardRowsLetters = convertCharsToStrings(num2cell(lettersList));
            end

            function gameBoardColumnsNumbers = generateGameBoardColumnsNumbers()

                gameBoardWidth = size(chosenBoard, 2);
                gameBoardColumnsNumbers = string(1:gameBoardWidth);         
            end
        end

        function [rowItems, rowItemsData, columnItems, columnItemsData] = loadChosenGameBoardDropdownsValues(this, chosenBoard)
                
            [gameBoardRowsLetters, gameBoardColumnsNumbers] = this.generateChosenGameBoardLabels(chosenBoard);

            [rowItems, rowItemsData] = loadRowDropdownsValues();
            [columnItems, columnItemsData] = loadColumnDropdownsValues();

            function [rowItems, rowItemsData] = loadRowDropdownsValues()

                    gameBoardHeight = size(chosenBoard, 1);

                    rowItems = gameBoardRowsLetters;
                    rowItemsData = 1:gameBoardHeight;
            end

            function [columnItems, columnItemsData] = loadColumnDropdownsValues()

                    gameBoardWidth = size(chosenBoard, 2);

                    columnItems = gameBoardColumnsNumbers;
                    columnItemsData = 1:gameBoardWidth;
            end
        end

        function blueRgbMatrix = loadChosenBoardDefaultRgbMatrix(this, chosenBoard)

            gameBoardHeight = size(chosenBoard, 1);
            gameBoardWidth = size(chosenBoard, 2);

            blueRgbMatrix = this.createRgbMatrixFromGivenColor(gameBoardWidth, ...
                gameBoardHeight, DataManager.WATER_COLOR);
        end

        function resetPlayerColorBoard(this, loadedBoardImage)
                
            this.PlayerColorBoard = loadedBoardImage;
        end

        function resetEnemyShipsHitsColorBoard(this, loadedBoardImage)
                
            this.EnemyShipsHitsColorBoard = loadedBoardImage;
        end

        function [X, Y] = loadChosenColorBoardGridLinesCoordinates(~, chosenColorBoard)
            
            gameBoardWidth = size(chosenColorBoard.CData, 2);
            gameBoardHeight = size(chosenColorBoard.CData, 1);
            verticalLinesCount = gameBoardWidth - 1;
            horizontalLinesCount = gameBoardHeight - 1;
            
            X = loadXCoordinates();
            Y = loadYCoordinates();

            function X = loadXCoordinates()
                
                lastElementCenterXLocation = chosenColorBoard.XData(2);
                firstElementCenterXLocation = chosenColorBoard.XData(1);

                elementWidth = (lastElementCenterXLocation - firstElementCenterXLocation) / ...
                    (gameBoardWidth - 1);
                firstTickValue = firstElementCenterXLocation - elementWidth / 2;
                firstCoordinate = firstTickValue + elementWidth;

                xVerticalLines = loadVerticalLinesXCoordinates();
                xHorizontalLines = loadHorizontalLinesXCoordinates();
                            
                X = [xVerticalLines xHorizontalLines];

                function xVerticalLines = loadVerticalLinesXCoordinates()

                    xVerticalLines = firstCoordinate:elementWidth:gameBoardWidth;
                    xVerticalLines = repmat(xVerticalLines, 2, 1);
                end

                function xHorizontalLines = loadHorizontalLinesXCoordinates()
                    
                    lastTickValue = lastElementCenterXLocation + elementWidth / 2;
                    xHorizontalLines = [firstTickValue; 
                                        lastTickValue
                                       ];
                    xHorizontalLines = repmat(xHorizontalLines, 1, horizontalLinesCount);
                end
            end

            function Y = loadYCoordinates()
                
                lastElementCenterYLocation = chosenColorBoard.YData(2);
                firstElementCenterYLocation = chosenColorBoard.YData(1);

                elementHeight = (lastElementCenterYLocation - firstElementCenterYLocation) / ...
                    (gameBoardHeight - 1);
                firstTickValue = firstElementCenterYLocation - elementHeight / 2;
                firstCoordinate = firstTickValue + elementHeight;

                yVerticalLines = loadVerticalLinesYCoordinates();
                yHorizontalLines = loadHorizontalLinesYCoordinates();

                Y = [yVerticalLines yHorizontalLines];

                function yVerticalLines = loadVerticalLinesYCoordinates()

                    lastTickValue = lastElementCenterYLocation + elementHeight / 2;
                    yVerticalLines = [firstTickValue; 
                                      lastTickValue
                                     ];
                    yVerticalLines = repmat(yVerticalLines, 1, verticalLinesCount);
                end

                function yHorizontalLines = loadHorizontalLinesYCoordinates()
                                
                    yHorizontalLines = firstCoordinate:elementHeight:gameBoardHeight;
                    yHorizontalLines = repmat(yHorizontalLines, 2, 1);
                end
            end       
        end
        
        function resetData(this)
            
            resetDatabaseToDefaultState();
            resetGameBoards();
            resetEnemyShootingCoordinatesMemory();
            resetPlayerShootingCoordinatesMemory();
            this.resetPlayerBoardShipsAdditionOrder();

            function resetDatabaseToDefaultState()

                shipsTable = this.Database.ships;
                
                [shipsTable.coordinates] = deal(double.empty(0, 2));
                [shipsTable.health] = deal(logical.empty(0, 1));

                this.Database.ships = shipsTable;
            end

            function resetGameBoards()
                
                gameBoardArea = uint32(zeros(10, 10));

                this.PlayerBoard = gameBoardArea;
                this.EnemyBoard = gameBoardArea;
            end

            function resetEnemyShootingCoordinatesMemory()

                this.EnemyShootingCoordinatesMemory = double.empty(0, 2);
            end

            function resetPlayerShootingCoordinatesMemory()

                this.PlayerShootingCoordinatesMemory = double.empty(0, 2);
            end
        end

        function [shipsTypesIds, playerShipsCountAsString, ...
                  shipTypesNames, shipTypesDimensionsAsStrings ...
                 ] = loadShipsListBoxValues(this)

            shipTypesTable = this.Database.shipTypes;
            sortedShipTypes = this.sortDatabaseTable(shipTypesTable);
            
            shipsTypesIds = loadsortedShipsTypesIds();
            playerShipsCountAsString = loadPlayerShipsCountByShipType();
            shipTypesNames = loadShipTypesNames();
            shipTypesDimensionsAsStrings = loadShipTypesDimensions();

            function shipsTypesIds = loadsortedShipsTypesIds()

                shipsTypesIds = [sortedShipTypes.id];
            end

            function playerShipsCountAsString = loadPlayerShipsCountByShipType()

                shipsTable = this.Database.ships;

                playerShipsCondition = [shipsTable.ownerId] == DataManager.PLAYER_ID;
                playerShips = shipsTable(playerShipsCondition);
                playerShipsShipTypeIds = [playerShips.shipTypeId];

                playerShipsCountByShipType = arrayfun(@(shipTypeId) ...
                length(playerShips(playerShipsShipTypeIds == shipTypeId)) , shipsTypesIds);
                playerShipsCountAsString = strcat("Počet: ", string(playerShipsCountByShipType));
            end

            function shipTypesNames = loadShipTypesNames()

                shipTypesNames = strcat("Typ lodi: ", string([sortedShipTypes.name]));
            end

            function shipTypesDimensionsAsStrings = loadShipTypesDimensions()
                
                shipTypesShapes = {sortedShipTypes.shape};
                shipTypesDimensions = cellfun(@(shape) size(shape), ...
                    shipTypesShapes, UniformOutput=false).';
                shipTypesDimensionsAsMatrix = cell2mat(shipTypesDimensions);

                shipTypeFirstDimension = string(shipTypesDimensionsAsMatrix(1:end, 1));
                shipTypeSecondDimension = string(shipTypesDimensionsAsMatrix(1:end, 2));

                shipTypeDimensionsAsString = strcat(shipTypeFirstDimension, "×", ...
                    shipTypeSecondDimension);
                shipTypesDimensionsAsStrings = strcat("Rozměry: ", shipTypeDimensionsAsString);
                shipTypesDimensionsAsStrings = shipTypesDimensionsAsStrings.';
            end
        end

        function [shipsCountByShipTypeAsString, lastAddedShipShipTypeId] = loadShipsListBoxUpdatedValues(this)
            
            shipsTable = this.Database.ships;
            playerShipsCondition = [shipsTable.ownerId] == DataManager.PLAYER_ID;
            playerShips = shipsTable(playerShipsCondition);
                        
            lastAddedShipShipTypeId = loadLastAddedShipShipTypeId();
            shipsCountByShipTypeAsString = loadShipsCountByShipType();

            function lastAddedShipShipTypeId = loadLastAddedShipShipTypeId()

                lastAddedShipId = this.PlayerBoardShipsAdditionOrder(end);
                lastAddedShipShipTypeId = playerShips([playerShips.id] == lastAddedShipId).shipTypeId;
            end

            function shipsCountByShipTypeAsString = loadShipsCountByShipType()

                playerShipsByShipType = playerShips([playerShips.shipTypeId] == lastAddedShipShipTypeId);
                [logicalMask, ~] = ismember([playerShipsByShipType.id], this.PlayerBoard);
                positionedShipsCount = length(logicalMask(logicalMask == true));

                shipsCountByShipType = length(playerShipsByShipType) - positionedShipsCount;
                shipsCountByShipTypeAsString = strcat("Počet: ", string(shipsCountByShipType));
            end

        end
    end
end