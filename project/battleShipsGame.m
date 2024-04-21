classdef battleShipsGame < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        BattleShipsGameUIFigure         matlab.ui.Figure
        BasicGrid                       matlab.ui.container.GridLayout
        TabGroup                        matlab.ui.container.TabGroup
        GameAreaTab                     matlab.ui.container.Tab
        GameAreaTabGrid                 matlab.ui.container.GridLayout
        GameAreaTabFirstRow             matlab.ui.container.GridLayout
        GameMenuPanel                   matlab.ui.container.Panel
        GameMenuPanelGrid               matlab.ui.container.GridLayout
        StartGameButton                 matlab.ui.control.Button
        EndGameButton                   matlab.ui.control.Button
        GameStatePanel                  matlab.ui.container.Panel
        GameStatePanelGrid              matlab.ui.container.GridLayout
        GameStateTextArea               matlab.ui.control.TextArea
        Label_2                         matlab.ui.control.Label
        GameAreaTabSecondRow            matlab.ui.container.GridLayout
        ShipsSelectPanel                matlab.ui.container.Panel
        ShipsSelectPanelGrid            matlab.ui.container.GridLayout
        ShipsListBox                    matlab.ui.control.ListBox
        ShipsSelectPanelSecondRow       matlab.ui.container.GridLayout
        PlayerBoardColumnDropdownLabel  matlab.ui.control.Label
        PlayerBoardColumnDropdown       matlab.ui.control.DropDown
        PlayerBoardRowDropdownLabel     matlab.ui.control.Label
        PlayerBoardRowDropdown          matlab.ui.control.DropDown
        PlayerBoardShipOrientationDropdownLabel  matlab.ui.control.Label
        PlayerBoardShipOrientationDropdown  matlab.ui.control.DropDown
        ShipsSelectPanelThirdRow        matlab.ui.container.GridLayout
        AddShipButton                   matlab.ui.control.Button
        RemoveLastAddedShipButton       matlab.ui.control.Button
        RemoveAllAddedShipsButton       matlab.ui.control.Button
        PlayerGameBoardPanel            matlab.ui.container.Panel
        PlayerGameBoardPanelGrid        matlab.ui.container.GridLayout
        PlayerGameBoardUIAxes           matlab.ui.control.UIAxes
        EnemyShipsHitsPanel             matlab.ui.container.Panel
        EnemyShipsHitsPanelGrid         matlab.ui.container.GridLayout
        EnemyShipsHitsPanelSecondRow    matlab.ui.container.GridLayout
        EnemyShipsHitsColumnDropdownLabel  matlab.ui.control.Label
        EnemyShipsHitsColumnDropdown    matlab.ui.control.DropDown
        EnemyShipsHitsRowDropdownLabel  matlab.ui.control.Label
        EnemyShipsHitsRowDropdown       matlab.ui.control.DropDown
        ShootButton                     matlab.ui.control.Button
        EnemyShipsHitsUIAxes            matlab.ui.control.UIAxes
        MadeMovesHistoryTab             matlab.ui.container.Tab
        MadeMovesHistoryTabGrid         matlab.ui.container.GridLayout
        MadeMovesHistoryTextArea        matlab.ui.control.TextArea
    end

    properties (Constant)

        DataManager = DataManager;
        Timer = timer("BusyMode", "queue");
    end
    
    methods (Access = private)
        
        function resetGameSession(app)

            resetUIElementsVisibility();
            app.DataManager.resetData();
            resetGameColorBoards();
            loadShipsListBoxContent(app);
            clearTextAreas();

            function resetUIElementsVisibility()
                
                resetGameMenuPanelUIArea();
                resetShipsSelectPanelUIArea();
                disableEnemyShipsHitsPanelUIArea();
                disablePlayerGameBoardPanelUIArea();

                function resetGameMenuPanelUIArea()

                    app.StartGameButton.Enable = "on";
                    app.EndGameButton.Enable = "off";
                end

                function resetShipsSelectPanelUIArea()
                    
                    app.ShipsSelectPanelGrid.Visible = "on";

                    app.ShipsListBox.Enable = "off";

                    app.PlayerBoardColumnDropdownLabel.Enable = "off";
                    app.PlayerBoardColumnDropdown.Enable = "off";

                    app.PlayerBoardRowDropdownLabel.Enable = "off";
                    app.PlayerBoardRowDropdown.Enable = "off";

                    app.PlayerBoardShipOrientationDropdownLabel.Enable = "off";
                    app.PlayerBoardShipOrientationDropdown.Enable = "off";

                    app.AddShipButton.Enable = "off";
                    app.RemoveLastAddedShipButton.Enable = "off";
                    app.RemoveAllAddedShipsButton.Enable = "off";
                end

                function disableEnemyShipsHitsPanelUIArea()

                    app.EnemyShipsHitsPanelGrid.Visible = "off";

                    app.EnemyShipsHitsColumnDropdownLabel.Enable = "on";
                    app.EnemyShipsHitsColumnDropdown.Enable = "on";

                    app.EnemyShipsHitsRowDropdownLabel.Enable = "on";
                    app.EnemyShipsHitsRowDropdown.Enable = "on";

                    app.ShootButton.Enable = "on";
                end

                function disablePlayerGameBoardPanelUIArea()

                    app.PlayerGameBoardPanelGrid.Visible = "off";
                end
            end

            function clearTextAreas()
                
                clearGameStatePanelUIArea();
                clearMadeMovesHistoryTabUIArea();

                function clearGameStatePanelUIArea()

                    app.GameStateTextArea.Value = "";
                end

                function clearMadeMovesHistoryTabUIArea()

                    app.MadeMovesHistoryTextArea.Value = "";
                    app.MadeMovesHistoryTextArea.Placeholder = "";
                end
            end

            function resetGameColorBoards()

                resetPlayerColorBoard();
                resetEnemyShipsHitsColorBoard();
            
                function resetPlayerColorBoard()

                    resetBoardColor();
                    createBoardGrid();
                    
                    function resetBoardColor()

                        playerBoardBlueRgbMatrix =  app.DataManager.loadChosenBoardDefaultRgbMatrix(app.DataManager.PlayerBoard);
                        playerBoardImage = image(app.PlayerGameBoardUIAxes, playerBoardBlueRgbMatrix, "XData", [1 size(playerBoardBlueRgbMatrix, 2)], ...
                            "YData", [1 size(playerBoardBlueRgbMatrix, 1)]);
                        app.DataManager.resetPlayerColorBoard(playerBoardImage);
                    end
                    
                    function createBoardGrid()

                        [X, Y] = app.DataManager.loadChosenColorBoardGridLinesCoordinates(app.DataManager.PlayerColorBoard);

                        drawLinesIntoBoard();
                        
                        function drawLinesIntoBoard()

                            line(app.PlayerGameBoardUIAxes, X, Y, 'Color', 'black', 'LineWidth', 3.5);
                        end
                    end
                end

                function resetEnemyShipsHitsColorBoard()

                    resetBoardColor();
                    createBoardGrid();
                    
                    function resetBoardColor()

                        enemyBoardBlueRgbMatrix =  app.DataManager.loadChosenBoardDefaultRgbMatrix(app.DataManager.EnemyBoard);
                        enemyBoardImage = image(app.EnemyShipsHitsUIAxes, enemyBoardBlueRgbMatrix, "XData", [1 size(enemyBoardBlueRgbMatrix, 2)], ...
                            "YData", [1 size(enemyBoardBlueRgbMatrix, 1)]);
                        app.DataManager.resetEnemyShipsHitsColorBoard(enemyBoardImage);
                    end
                    
                    function createBoardGrid()

                        [X, Y] = app.DataManager.loadChosenColorBoardGridLinesCoordinates(app.DataManager.EnemyShipsHitsColorBoard);

                        drawLinesIntoBoard();
                        
                        function drawLinesIntoBoard()

                            line(app.EnemyShipsHitsUIAxes, X, Y, 'Color', 'black', 'LineWidth', 3.5);
                        end
                    end
                end
            end
        end

        function displayGameMessage(app, message, isMessageTypeMadeMove)
            
            app.GameStateTextArea.Value = message;

            if isMessageTypeMadeMove == true

                addMadeGameMoveToHistory();
            end
            
            function addMadeGameMoveToHistory()

                currentTime = datetime;
                formattedCurrentTime = string(currentTime, "HH:mm:ss");

                formattedMessage = sprintf("\n%s: %s", formattedCurrentTime, message);
                app.MadeMovesHistoryTextArea.Value{end + 1} = char(formattedMessage);
            end
        end

        function loadShipsListBoxContent(app)

            [shipsTypesIds, playerShipsCountAsString, ...
                shipTypesNames, shipTypesDimensionsAsStrings] =  app.DataManager.loadShipsListBoxValues();
                
            updateListBox();

            function updateListBox()
                    
                listBoxItems = strcat(playerShipsCountAsString, ... 
                        " || " , shipTypesNames, " || ", shipTypesDimensionsAsStrings);

                app.ShipsListBox.Items = listBoxItems;
                app.ShipsListBox.ItemsData = shipsTypesIds;
                app.ShipsListBox.Value = shipsTypesIds(1);
            end
        end

        function changeAddShipButtonStateConditionally(app, conditionResult)

            if conditionResult == false

                app.AddShipButton.Enable = "off";
            else

                app.AddShipButton.Enable = "on";
            end
        end

        function deactivateShipsRemovalButtons(app)
                
            app.RemoveLastAddedShipButton.Enable = "off";
            app.RemoveAllAddedShipsButton.Enable = "off";
        end

        function changeEndGameButtonState(app)

            currentState = app.EndGameButton.Enable;

            if currentState == "off"

                app.EndGameButton.Enable = "on";
            else

                app.EndGameButton.Enable = "off";
            end
        end

        function updateShipsListBox(app, shipsCountByShipTypeAsString, addedShipShipTypeId)

            shipTypeItemPosition = loadShipTypeItemPosition();
            shipTypeItemAsString = loadShipTypeItemAsString();
            newTypeItem = updateShipTypeItem();

            app.ShipsListBox.Items(shipTypeItemPosition) = cellstr(newTypeItem);

            function shipTypeItemPosition = loadShipTypeItemPosition()

                shipTypeIds = app.ShipsListBox.ItemsData;
                shipTypeItemPosition = find(shipTypeIds == addedShipShipTypeId);
            end
                
            function shipTypeItemAsString = loadShipTypeItemAsString()

                shipTypeItemAsString = app.ShipsListBox.Items(shipTypeItemPosition);
                shipTypeItemAsString = string(shipTypeItemAsString);
            end
                
            function newTypeItem = updateShipTypeItem()

                splittedTypeItem = split(shipTypeItemAsString, "||");
                splittedTypeItem(1) = strcat(shipsCountByShipTypeAsString, " ");

                newTypeItem = strcat(splittedTypeItem(1), "||", ...
                    splittedTypeItem(2), "||", splittedTypeItem(3));
            end
        end

        function startTimer(app, timerFcn, numberOfSeconds, stopFcn)
            
            if nargin == 4

                app.Timer.StopFcn = stopFcn;

            else

                app.Timer.StopFcn = '';
            end
            
            app.Timer.TimerFcn = timerFcn;
            app.Timer.StartDelay = numberOfSeconds;
            start(app.Timer);
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
        
            resetGameSession(app);
            loadDropdownsContent();
            createGameColorBoardsPlacements();
            createPlayerColorBoardLegendsList();
            
            function loadDropdownsContent()
                
                orientationDropdownItemsData = loadShipOrientationDropdownValues();

                [playerBoardRowDropdownItems, playerBoardRowDropdownItemsData, ...
                    playerBoardColumnDropdownItems, playerBoardColumnDropdownItemsData] = ...
                app.DataManager.loadChosenGameBoardDropdownsValues(app.DataManager.PlayerBoard);

                [enemyBoardRowDropdownItems, enemyBoardRowDropdownItemsData, ...
                    enemyBoardColumnDropdownItems, enemyBoardColumnDropdownItemsData] = ...
                app.DataManager.loadChosenGameBoardDropdownsValues(app.DataManager.EnemyBoard);

                updateDropdowns();

                function itemsData = loadShipOrientationDropdownValues()
                
                    itemsData = [ShipOrientationsEnum.Upwards.getValue(), ...
                        ShipOrientationsEnum.Downwards.getValue(),ShipOrientationsEnum.Left.getValue(), ...
                        ShipOrientationsEnum.Right.getValue()];
                end

                function updateDropdowns()

                    updatePlayerBoardShipOrientationDropdown();
                    updateEnemyShipsHitsRowDropdown();
                    updateEnemyShipsHitsColumnDropdown();
                    updatePlayerBoardRowDropdown();
                    updatePlayerBoardColumnDropdown();
                    
                    function updatePlayerBoardShipOrientationDropdown()

                        app.PlayerBoardShipOrientationDropdown.ItemsData = ...
                            orientationDropdownItemsData;
                    end

                    function updateEnemyShipsHitsRowDropdown()

                        app.EnemyShipsHitsRowDropdown.Items = enemyBoardRowDropdownItems;
                        app.EnemyShipsHitsRowDropdown.ItemsData = enemyBoardRowDropdownItemsData;
                    end

                    function updateEnemyShipsHitsColumnDropdown()

                        app.EnemyShipsHitsColumnDropdown.Items = enemyBoardColumnDropdownItems;
                        app.EnemyShipsHitsColumnDropdown.ItemsData = enemyBoardColumnDropdownItemsData;
                    end
                    
                    function updatePlayerBoardRowDropdown()

                        app.PlayerBoardRowDropdown.Items = playerBoardRowDropdownItems;
                        app.PlayerBoardRowDropdown.ItemsData = playerBoardRowDropdownItemsData;
                    end

                    function updatePlayerBoardColumnDropdown()

                        app.PlayerBoardColumnDropdown.Items = playerBoardColumnDropdownItems;
                        app.PlayerBoardColumnDropdown.ItemsData = playerBoardColumnDropdownItemsData;
                    end
                end
            end

            function createGameColorBoardsPlacements()
                
                playerAxes = createChosenColorBoardPlacement(app.PlayerGameBoardUIAxes, ...
                    app.DataManager.PlayerBoard);

                enemyAxes = createChosenColorBoardPlacement(app.EnemyShipsHitsUIAxes, ...
                    app.DataManager.EnemyBoard);

                updateOriginalAxesWithNewAxes();
                
                function updateOriginalAxesWithNewAxes()

                    app.PlayerGameBoardUIAxes = playerAxes;
                    app.EnemyShipsHitsUIAxes = enemyAxes;
                end
                
                function chosenAxes = createChosenColorBoardPlacement(chosenAxes, chosenBoard)
                    
                    [gameBoardRowsLetters, gameBoardColumnsNumbers] = app.DataManager.generateChosenGameBoardLabels(chosenBoard);

                    setBasicBoardPlacementSettings();
                    createBoardPlacementColumnsAndRowsLabels();
 
                    function createBoardPlacementColumnsAndRowsLabels()
                        
                        chosenAxes.XTick = double(gameBoardColumnsNumbers);
                        chosenAxes.XTickLabel = gameBoardColumnsNumbers;
                        chosenAxes.YTick = double(gameBoardColumnsNumbers);
                        chosenAxes.YTickLabel = gameBoardRowsLetters;
                    end

                    function setBasicBoardPlacementSettings()

                        axis(chosenAxes, "image");

                        chosenAxes.LineWidth = 7;
                        chosenAxes.XRuler.TickLabelGapOffset = 5;
                        chosenAxes.YRuler.TickLabelGapOffset = 5;
                    end
                end
            end

            function createPlayerColorBoardLegendsList()
                
                shipTypesNames = app.DataManager.loadShipTypesNames();
                shipTypesCount = length(shipTypesNames);
                subset = createShipTypesGraphicalRepresentations();
                    
                legendsBox = legend(app.PlayerGameBoardUIAxes, subset, ...
                    shipTypesNames, "Location", "northoutside", "LineWidth", 1, ...
                    "PickableParts", "none", "HitTest", "off", "AutoUpdate", "off");
                title(legendsBox,'Legendy typů lodí');

                function subset = createShipTypesGraphicalRepresentations()

                    tempAxes = axes(app.BattleShipsGameUIFigure);
                    subset = line(tempAxes, ones(shipTypesCount), ones(shipTypesCount));
                    shipTypesColors = app.DataManager.loadShipTypesColors();

                    set(subset(:), "Linewidth", 7);

                    for elementOrder = 1:shipTypesCount

                        set(subset(elementOrder), "Color", ...
                            shipTypesColors(elementOrder, 1:length(app.DataManager.WATER_COLOR)));
                    end
                end
            end
        end

        % Button pushed function: StartGameButton
        function StartGameButtonPushed(app, event)
            
            displayGameMessage(app, "Rozmísti si své lodě na svou herní desku", false);
            initMadeMovesHistoryTextArea();
            changeUIElementsVisibility();

            function changeUIElementsVisibility()

                activateShipsSelectPanelUIArea();
                activatePlayerGameBoardPanelUIArea();
                updateGameMenuPanelUIArea();

                function activateShipsSelectPanelUIArea()

                    app.ShipsListBox.Enable = "on";

                    app.PlayerBoardColumnDropdownLabel.Enable = "on";
                    app.PlayerBoardColumnDropdown.Enable = "on";

                    app.PlayerBoardRowDropdownLabel.Enable = "on";
                    app.PlayerBoardRowDropdown.Enable = "on";

                    app.PlayerBoardShipOrientationDropdownLabel.Enable = "on";
                    app.PlayerBoardShipOrientationDropdown.Enable = "on";

                    app.AddShipButton.Enable = "on";    
                    app.RemoveLastAddedShipButton.Enable = "off";
                    app.RemoveAllAddedShipsButton.Enable = "off";
                end

                function updateGameMenuPanelUIArea()

                    app.StartGameButton.Enable = "off";
                    app.EndGameButton.Enable = "on";
                end

                function activatePlayerGameBoardPanelUIArea()

                    app.PlayerGameBoardPanelGrid.Visible = "on";
                end
            end

            function initMadeMovesHistoryTextArea()

                app.MadeMovesHistoryTextArea.Placeholder = "Zde se zobrazí " + ...
                "všechny vaše a nepřítelovy tahy během této aktuální hry";
            end
        end

        % Button pushed function: EndGameButton
        function EndGameButtonPushed(app, event)
            resetGameSession(app);
        end

        % Value changed function: ShipsListBox
        function ShipsListBoxValueChanged(app, event)
            
            shipTypeId = app.ShipsListBox.Value;
            isNotSelected = checkIfShipIsSelected();

            if isNotSelected

                app.AddShipButton.Enable = "off";
                
                return;
            end
            
            areThereAnyUnpositionedShipsOfThisShipType = app.DataManager.checkRemainingUnpositionedShipsByShipType(shipTypeId, ...
                app.DataManager.PLAYER_ID, app.DataManager.PlayerBoard);

            changeAddShipButtonStateConditionally(app, areThereAnyUnpositionedShipsOfThisShipType);

            function isNotSelected = checkIfShipIsSelected()

                isNotSelected = isempty(shipTypeId);
            end
        end

        % Button pushed function: AddShipButton
        function AddShipButtonPushed(app, event)
            
            [shipOrientation, gameBoardRow, gameBoardColumn, ...
                shipTypeId] = loadSelectedValues();
            
            [errorType] = app.DataManager.tryAddShipOnPlayerGameBoard(shipOrientation, ...
                gameBoardRow, gameBoardColumn, shipTypeId);

            if errorType ~= app.DataManager.ErrorTypesEnum.None

                handleOccuredErrors();

                return;
            end
          
            ShipsListBoxValueChanged(app, event);

            if app.RemoveLastAddedShipButton.Enable == "off"
                
                activateShipsRemovalButtons();
            end
            
            [shipsCountByShipTypeAsString, addedShipShipTypeId] = app.DataManager.loadShipsListBoxUpdatedValues();
            updateShipsListBox(app, shipsCountByShipTypeAsString, addedShipShipTypeId);

            areThereAnyUnpositionedShips = app.DataManager.checkAllRemainingUnpositionedShips(app.DataManager.PLAYER_ID, ...
                app.DataManager.PlayerBoard);

            if areThereAnyUnpositionedShips == false

                transitionToNextGamePhase();
            end

            function transitionToNextGamePhase()
                
                disableShipsSelectPanelUIArea();
                changeEndGameButtonState(app);
                displayGameMessage(app, "Čeká se na dokončení rozmisťování lodí nepřítele", false);

                app.DataManager.addShipsOnEnemyGameBoard();
                startTimer(app, @(~,~) displayGameMessage(app, "Hra začíná, hráč je na tahu", false), ...
                    4, @(~, ~) activateNextGamePhase(app));

                function disableShipsSelectPanelUIArea()

                    app.ShipsSelectPanelGrid.Visible = "off";
                end

                function activateNextGamePhase(app)

                    app.EnemyShipsHitsPanelGrid.Visible = "on";
                    changeEndGameButtonState(app);
                end
            end

            function activateShipsRemovalButtons()
                
                app.RemoveLastAddedShipButton.Enable = "on";
                app.RemoveAllAddedShipsButton.Enable = "on";
            end

            function handleOccuredErrors()

                switch errorType
                
                    case app.DataManager.ErrorTypesEnum.OutOfBoundsUpwards

                        uialert(app.BattleShipsGameUIFigure, ['Vkládaná loď překračuje ' ...
                            'hranice horní části herní desky'], ...
                            'Chyba při vkládání lodi na herní desku');

                    case app.DataManager.ErrorTypesEnum.OutOfBoundsDownwards

                        uialert(app.BattleShipsGameUIFigure, ['Vkládaná loď překračuje ' ...
                            'hranice dolní části herní desky'], ...
                            'Chyba při vkládání lodi na herní desku');

                    case app.DataManager.ErrorTypesEnum.OutOfBoundsLeft   
                        
                        uialert(app.BattleShipsGameUIFigure, ['Vkládaná loď překračuje ' ...
                            'hranice levé části herní desky'], ...
                            'Chyba při vkládání lodi na herní desku');

                    case app.DataManager.ErrorTypesEnum.OutOfBoundsRight
                        
                        uialert(app.BattleShipsGameUIFigure, ['Vkládaná loď překračuje ' ...
                            'hranice pravé části herní desky'], ...
                            'Chyba při vkládání lodi na herní desku');

                    case app.DataManager.ErrorTypesEnum.CollidedOccupied
                        
                        uialert(app.BattleShipsGameUIFigure, ['Vkládaná loď se překrývá' ...
                            ' s již existující lodí'], ...
                            'Chyba při vkládání lodi na herní desku');

                    case app.DataManager.ErrorTypesEnum.CollidedTouching

                        uialert(app.BattleShipsGameUIFigure, ['Vkládaná loď se dotýká' ...
                            ' stěnou nebo rohem s již existující lodí'], ...
                            'Chyba při vkládání lodi na herní desku');
                end
            end

            function [shipOrientation, gameBoardRow, gameBoardColumn, ...
                      shipTypeId ...
                     ] = loadSelectedValues()
                
                shipOrientation = loadShipOrientationValue();
                gameBoardColumn = loadGameBoardColumnValue();
                gameBoardRow = loadGameBoardRowValue();
                shipTypeId = loadShipTypeIdValue();

                function shipOrientation = loadShipOrientationValue()

                    shipOrientation = app.PlayerBoardShipOrientationDropdown.Value;
                end

                function shipTypeId = loadShipTypeIdValue()

                    shipTypeId = app.ShipsListBox.Value;
                end

                function gameBoardColumn = loadGameBoardColumnValue()

                    gameBoardColumn = app.PlayerBoardColumnDropdown.Value;
                end

                function gameBoardRow = loadGameBoardRowValue()
                
                    gameBoardRow = app.PlayerBoardRowDropdown.Value;
                end
            end
        end

        % Button pushed function: RemoveLastAddedShipButton
        function RemoveLastAddedShipButtonPushed(app, event)
            
            [shipsCountByShipTypeAsString, removedShipShipTypeId] = app.DataManager.removeLastAddedShip();
            
            shipcCountByShipType = str2double(extract(shipsCountByShipTypeAsString, digitsPattern));

            if removedShipShipTypeId == app.ShipsListBox.Value && shipcCountByShipType == 1

                changeAddShipButtonStateConditionally(app, true);
            end
            
            areAllShipsUnpositioned = app.DataManager.checkAllAlreadyPositionedShips();

            if areAllShipsUnpositioned == true
                
                deactivateShipsRemovalButtons(app);
            end

            updateShipsListBox(app, shipsCountByShipTypeAsString, removedShipShipTypeId)
        end

        % Button pushed function: RemoveAllAddedShipsButton
        function RemoveAllAddedShipsButtonPushed(app, event)
            
            changeEndGameButtonState(app);
            deactivateShipsRemovalButtons(app);
            
            app.DataManager.removeAllAddedShips();
            
            loadShipsListBoxContent(app);
            ShipsListBoxValueChanged(app, event);

            changeEndGameButtonState(app);
        end

        % Button pushed function: ShootButton
        function ShootButtonPushed(app, event)
            
            changeShootButtonState(app);
            changeEndGameButtonState(app);

            [gameBoardRow, gameBoardColumn] = loadSelectedValues();
            wasPlayerShooting = true;

            shipShootStatus = app.DataManager.fireOnEnemyBoard(gameBoardRow, gameBoardColumn);
            
            drawMarkingOnGameColorBoard();

            areAllEnemyShipsSunken = app.DataManager.checkIfPlayerWon(app.DataManager.ENEMY_ID);

            if areAllEnemyShipsSunken == true
                
                displayGameMessage(app, "Vyhráli jste. Všechny nepřátelské lodě zničeny.", false);
                startTimer(app, @(~,~) resetGameSession(app), 5);

                return;
            end

            gameMessageContent = loadGameMessageContent();
            displayGameMessage(app, gameMessageContent, true);

            startTimer(app, @(~,~) takeEnemyTurn(app), 7, @(~,~) enemyFires(app));

            function enemyFires(app)
                    
                wasPlayerShooting = false;
                    
                [shipShootStatus, gameBoardRow, gameBoardColumn] = app.DataManager.fireOnPlayerBoard();
                
                drawMarkingOnGameColorBoard();

                areAllPlayerShipsSunken = app.DataManager.checkIfPlayerWon(app.DataManager.PLAYER_ID);

                if areAllPlayerShipsSunken == true

                    displayGameMessage(app, "Prohráli jste. Všechny hráčovy lodě zničeny", false);
                    startTimer(app, @(~,~) resetGameSession(app), 5);

                    return;
                end

                gameMessageContent = loadGameMessageContent();
                startTimer(app, @(~,~) displayGameMessage(app, gameMessageContent, true), ...
                    1.5, @(~,~) takePlayerTurn(app));
            end

            function takeEnemyTurn(app)
                
                displayGameMessage(app, "Nepřítel je na tahu", false);
            end

            function takePlayerTurn(app)
                
                startTimer(app, @(~,~) displayGameMessage(app, "Hráč je na tahu", false), 7, ...
                    @(~,~) resetGameTurnButtons(app));

                function resetGameTurnButtons(app)

                    changeEndGameButtonState(app);
                    changeShootButtonState(app);
                end
            end
           
            function drawMarkingOnGameColorBoard()
                
                if shipShootStatus == app.DataManager.ShipShootStatusEnum.ShipHit || ...
                    shipShootStatus == app.DataManager.ShipShootStatusEnum.ShipSunk
                        
                    drawCross();
                    
                elseif shipShootStatus == app.DataManager.ShipShootStatusEnum.WaterHit
                    
                    drawCircle();
                end

                function drawCross()

                    if wasPlayerShooting == true

                        [X, Y] = app.DataManager.loadGameColorBoardCrossCoordinates(app.DataManager.EnemyShipsHitsColorBoard, ...
                            gameBoardRow, gameBoardColumn);
                        
                        line(app.EnemyShipsHitsUIAxes, X, Y, 'Color', 'black', 'LineWidth', 2.5);

                    else

                        [X, Y] = app.DataManager.loadGameColorBoardCrossCoordinates(app.DataManager.PlayerColorBoard, ...
                            gameBoardRow, gameBoardColumn);
                        
                        line(app.PlayerGameBoardUIAxes, X, Y, 'Color', 'black', 'LineWidth', 2.5);
                    end
                end

                function drawCircle()

                    if wasPlayerShooting == true
                        
                        position = app.DataManager.loadCirclePosition(app.DataManager.EnemyShipsHitsColorBoard, ...
                            gameBoardRow, gameBoardColumn);

                        rectangle(app.EnemyShipsHitsUIAxes, 'Position', position, 'Curvature', [1 1], ...
                            'FaceColor', app.DataManager.BLACK_COLOR);

                    else

                        position = app.DataManager.loadCirclePosition(app.DataManager.PlayerColorBoard, ...
                            gameBoardRow, gameBoardColumn);

                        rectangle(app.PlayerGameBoardUIAxes, 'Position', position, 'Curvature', [1 1], ...
                            'FaceColor', app.DataManager.BLACK_COLOR);     
                    end
                end
            end

            function gameMessageContent = loadGameMessageContent()
                
                if wasPlayerShooting == true

                    rowCoordinateLetter = string(app.EnemyShipsHitsRowDropdown.Items(gameBoardRow));
                    
                    switch shipShootStatus

                        case app.DataManager.ShipShootStatusEnum.WaterHit

                            gameMessageContent = strcat("Hráč minul na souřadnicích ", ...
                                rowCoordinateLetter, string(gameBoardColumn));
                         
                        case app.DataManager.ShipShootStatusEnum.ShipHit

                            gameMessageContent = strcat("Hráč zasáhl loď na souřadnicích ", ...
                                rowCoordinateLetter, string(gameBoardColumn));

                        case app.DataManager.ShipShootStatusEnum.ShipSunk

                            gameMessageContent = strcat("Hráč potopil loď na souřadnicích ", ...
                                rowCoordinateLetter, string(gameBoardColumn));
                         
                        otherwise

                            gameMessageContent = strcat("Hráč minul na souřadnicích ", ...
                                rowCoordinateLetter, string(gameBoardColumn)); 
                    end
                else

                    rowCoordinateLetter = string(app.PlayerBoardRowDropdown.Items(gameBoardRow));

                    switch shipShootStatus

                        case app.DataManager.ShipShootStatusEnum.WaterHit

                            gameMessageContent = strcat("Nepřítel minul na souřadnicích ", ...
                                rowCoordinateLetter, string(gameBoardColumn));
                         
                        case app.DataManager.ShipShootStatusEnum.ShipHit

                             gameMessageContent = strcat("Nepřítel zasáhl loď na souřadnicích ", ...
                                rowCoordinateLetter, string(gameBoardColumn));

                        case app.DataManager.ShipShootStatusEnum.ShipSunk

                            gameMessageContent = strcat("Nepřítel potopil loď na souřadnicích ", ...
                                rowCoordinateLetter, string(gameBoardColumn));
                    end
                end
            end

            function changeShootButtonState(app)

                currentState = app.ShootButton.Enable;

                if currentState == "off"

                    app.ShootButton.Enable = "on";

                else

                    app.ShootButton.Enable = "off";
                end
            end

            function [gameBoardRow, gameBoardColumn] = loadSelectedValues()
                
                gameBoardColumn = loadGameBoardColumnValue();
                gameBoardRow = loadGameBoardRowValue();

                function gameBoardColumn = loadGameBoardColumnValue()

                    gameBoardColumn = app.EnemyShipsHitsColumnDropdown.Value;
                end

                function gameBoardRow = loadGameBoardRowValue()
                
                    gameBoardRow = app.EnemyShipsHitsRowDropdown.Value;
                end
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create BattleShipsGameUIFigure and hide until all components are created
            app.BattleShipsGameUIFigure = uifigure('Visible', 'off');
            app.BattleShipsGameUIFigure.Position = [100 100 640 480];
            app.BattleShipsGameUIFigure.Name = 'Battle Ships Game';
            app.BattleShipsGameUIFigure.Icon = fullfile(pathToMLAPP, 'build_data', 'battleShipsGame_resources', 'icon_original_size.jpg');

            % Create BasicGrid
            app.BasicGrid = uigridlayout(app.BattleShipsGameUIFigure);
            app.BasicGrid.ColumnWidth = {'1x'};
            app.BasicGrid.RowHeight = {'1x'};
            app.BasicGrid.ColumnSpacing = 0;
            app.BasicGrid.RowSpacing = 0;
            app.BasicGrid.Padding = [0 0 0 0];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.BasicGrid);
            app.TabGroup.Layout.Row = 1;
            app.TabGroup.Layout.Column = 1;

            % Create GameAreaTab
            app.GameAreaTab = uitab(app.TabGroup);
            app.GameAreaTab.Title = 'HERNÍ PLOCHA';
            app.GameAreaTab.BackgroundColor = [0.9412 0.9412 0.9412];

            % Create GameAreaTabGrid
            app.GameAreaTabGrid = uigridlayout(app.GameAreaTab);
            app.GameAreaTabGrid.ColumnWidth = {'1x'};
            app.GameAreaTabGrid.RowHeight = {'1x', '2.3x'};
            app.GameAreaTabGrid.ColumnSpacing = 0;
            app.GameAreaTabGrid.RowSpacing = 0;
            app.GameAreaTabGrid.Padding = [0 0 0 0];

            % Create GameAreaTabSecondRow
            app.GameAreaTabSecondRow = uigridlayout(app.GameAreaTabGrid);
            app.GameAreaTabSecondRow.ColumnWidth = {'1x', '1x', '1x'};
            app.GameAreaTabSecondRow.RowHeight = {'1x'};
            app.GameAreaTabSecondRow.ColumnSpacing = 0;
            app.GameAreaTabSecondRow.RowSpacing = 0;
            app.GameAreaTabSecondRow.Padding = [0 0 0 0];
            app.GameAreaTabSecondRow.Layout.Row = 2;
            app.GameAreaTabSecondRow.Layout.Column = 1;

            % Create EnemyShipsHitsPanel
            app.EnemyShipsHitsPanel = uipanel(app.GameAreaTabSecondRow);
            app.EnemyShipsHitsPanel.TitlePosition = 'centertop';
            app.EnemyShipsHitsPanel.Title = 'ZÁSAHY LODÍ NEPŘÍTELE';
            app.EnemyShipsHitsPanel.Layout.Row = 1;
            app.EnemyShipsHitsPanel.Layout.Column = 3;
            app.EnemyShipsHitsPanel.FontWeight = 'bold';
            app.EnemyShipsHitsPanel.FontSize = 24;

            % Create EnemyShipsHitsPanelGrid
            app.EnemyShipsHitsPanelGrid = uigridlayout(app.EnemyShipsHitsPanel);
            app.EnemyShipsHitsPanelGrid.ColumnWidth = {'1x'};
            app.EnemyShipsHitsPanelGrid.RowHeight = {'1x', '0.4x', '0.25x'};
            app.EnemyShipsHitsPanelGrid.Padding = [5 10 5 5];
            app.EnemyShipsHitsPanelGrid.Visible = 'off';

            % Create EnemyShipsHitsUIAxes
            app.EnemyShipsHitsUIAxes = uiaxes(app.EnemyShipsHitsPanelGrid);
            app.EnemyShipsHitsUIAxes.Toolbar.Visible = 'off';
            app.EnemyShipsHitsUIAxes.FontWeight = 'bold';
            app.EnemyShipsHitsUIAxes.XTick = [];
            app.EnemyShipsHitsUIAxes.XTickLabelRotation = 0;
            app.EnemyShipsHitsUIAxes.YTick = [];
            app.EnemyShipsHitsUIAxes.YTickLabelRotation = 0;
            app.EnemyShipsHitsUIAxes.FontSize = 16;
            app.EnemyShipsHitsUIAxes.SubtitleFontWeight = 'bold';
            app.EnemyShipsHitsUIAxes.Box = 'on';
            app.EnemyShipsHitsUIAxes.Layout.Row = 1;
            app.EnemyShipsHitsUIAxes.Layout.Column = 1;
            app.EnemyShipsHitsUIAxes.HitTest = 'off';
            app.EnemyShipsHitsUIAxes.PickableParts = 'none';

            % Create ShootButton
            app.ShootButton = uibutton(app.EnemyShipsHitsPanelGrid, 'push');
            app.ShootButton.ButtonPushedFcn = createCallbackFcn(app, @ShootButtonPushed, true);
            app.ShootButton.WordWrap = 'on';
            app.ShootButton.BackgroundColor = [0.302 0.4 0.9216];
            app.ShootButton.FontSize = 14;
            app.ShootButton.FontWeight = 'bold';
            app.ShootButton.FontColor = [1 1 1];
            app.ShootButton.Layout.Row = 3;
            app.ShootButton.Layout.Column = 1;
            app.ShootButton.Text = 'Vystřelit';

            % Create EnemyShipsHitsPanelSecondRow
            app.EnemyShipsHitsPanelSecondRow = uigridlayout(app.EnemyShipsHitsPanelGrid);
            app.EnemyShipsHitsPanelSecondRow.ColumnWidth = {'1x', '1.5x'};
            app.EnemyShipsHitsPanelSecondRow.Padding = [0 0 0 0];
            app.EnemyShipsHitsPanelSecondRow.Layout.Row = 2;
            app.EnemyShipsHitsPanelSecondRow.Layout.Column = 1;

            % Create EnemyShipsHitsRowDropdown
            app.EnemyShipsHitsRowDropdown = uidropdown(app.EnemyShipsHitsPanelSecondRow);
            app.EnemyShipsHitsRowDropdown.FontSize = 14;
            app.EnemyShipsHitsRowDropdown.FontWeight = 'bold';
            app.EnemyShipsHitsRowDropdown.BackgroundColor = [1 1 1];
            app.EnemyShipsHitsRowDropdown.Layout.Row = 1;
            app.EnemyShipsHitsRowDropdown.Layout.Column = 2;

            % Create EnemyShipsHitsRowDropdownLabel
            app.EnemyShipsHitsRowDropdownLabel = uilabel(app.EnemyShipsHitsPanelSecondRow);
            app.EnemyShipsHitsRowDropdownLabel.BackgroundColor = [1 1 1];
            app.EnemyShipsHitsRowDropdownLabel.HorizontalAlignment = 'center';
            app.EnemyShipsHitsRowDropdownLabel.FontSize = 14;
            app.EnemyShipsHitsRowDropdownLabel.Layout.Row = 1;
            app.EnemyShipsHitsRowDropdownLabel.Layout.Column = 1;
            app.EnemyShipsHitsRowDropdownLabel.Text = 'Řádek desky';

            % Create EnemyShipsHitsColumnDropdown
            app.EnemyShipsHitsColumnDropdown = uidropdown(app.EnemyShipsHitsPanelSecondRow);
            app.EnemyShipsHitsColumnDropdown.FontSize = 14;
            app.EnemyShipsHitsColumnDropdown.FontWeight = 'bold';
            app.EnemyShipsHitsColumnDropdown.BackgroundColor = [1 1 1];
            app.EnemyShipsHitsColumnDropdown.Layout.Row = 2;
            app.EnemyShipsHitsColumnDropdown.Layout.Column = 2;

            % Create EnemyShipsHitsColumnDropdownLabel
            app.EnemyShipsHitsColumnDropdownLabel = uilabel(app.EnemyShipsHitsPanelSecondRow);
            app.EnemyShipsHitsColumnDropdownLabel.BackgroundColor = [1 1 1];
            app.EnemyShipsHitsColumnDropdownLabel.HorizontalAlignment = 'center';
            app.EnemyShipsHitsColumnDropdownLabel.FontSize = 14;
            app.EnemyShipsHitsColumnDropdownLabel.Layout.Row = 2;
            app.EnemyShipsHitsColumnDropdownLabel.Layout.Column = 1;
            app.EnemyShipsHitsColumnDropdownLabel.Text = 'Sloupec desky';

            % Create PlayerGameBoardPanel
            app.PlayerGameBoardPanel = uipanel(app.GameAreaTabSecondRow);
            app.PlayerGameBoardPanel.TitlePosition = 'centertop';
            app.PlayerGameBoardPanel.Title = 'TVOJE HERNÍ DESKA';
            app.PlayerGameBoardPanel.Layout.Row = 1;
            app.PlayerGameBoardPanel.Layout.Column = 2;
            app.PlayerGameBoardPanel.FontWeight = 'bold';
            app.PlayerGameBoardPanel.FontSize = 24;

            % Create PlayerGameBoardPanelGrid
            app.PlayerGameBoardPanelGrid = uigridlayout(app.PlayerGameBoardPanel);
            app.PlayerGameBoardPanelGrid.ColumnWidth = {'1x'};
            app.PlayerGameBoardPanelGrid.RowHeight = {'1x'};
            app.PlayerGameBoardPanelGrid.ColumnSpacing = 0;
            app.PlayerGameBoardPanelGrid.RowSpacing = 0;
            app.PlayerGameBoardPanelGrid.Padding = [5 5 5 5];
            app.PlayerGameBoardPanelGrid.Visible = 'off';

            % Create PlayerGameBoardUIAxes
            app.PlayerGameBoardUIAxes = uiaxes(app.PlayerGameBoardPanelGrid);
            app.PlayerGameBoardUIAxes.Toolbar.Visible = 'off';
            app.PlayerGameBoardUIAxes.FontWeight = 'bold';
            app.PlayerGameBoardUIAxes.XTick = [];
            app.PlayerGameBoardUIAxes.XTickLabelRotation = 0;
            app.PlayerGameBoardUIAxes.YTick = [];
            app.PlayerGameBoardUIAxes.YTickLabelRotation = 0;
            app.PlayerGameBoardUIAxes.FontSize = 16;
            app.PlayerGameBoardUIAxes.SubtitleFontWeight = 'bold';
            app.PlayerGameBoardUIAxes.Box = 'on';
            app.PlayerGameBoardUIAxes.Layout.Row = 1;
            app.PlayerGameBoardUIAxes.Layout.Column = 1;
            app.PlayerGameBoardUIAxes.HitTest = 'off';
            app.PlayerGameBoardUIAxes.PickableParts = 'none';

            % Create ShipsSelectPanel
            app.ShipsSelectPanel = uipanel(app.GameAreaTabSecondRow);
            app.ShipsSelectPanel.TitlePosition = 'centertop';
            app.ShipsSelectPanel.Title = 'VÝBĚR TVÝCH LODÍ';
            app.ShipsSelectPanel.Layout.Row = 1;
            app.ShipsSelectPanel.Layout.Column = 1;
            app.ShipsSelectPanel.FontWeight = 'bold';
            app.ShipsSelectPanel.FontSize = 24;

            % Create ShipsSelectPanelGrid
            app.ShipsSelectPanelGrid = uigridlayout(app.ShipsSelectPanel);
            app.ShipsSelectPanelGrid.ColumnWidth = {'1x'};
            app.ShipsSelectPanelGrid.RowHeight = {'0.5x', '1x', '1x'};

            % Create ShipsSelectPanelThirdRow
            app.ShipsSelectPanelThirdRow = uigridlayout(app.ShipsSelectPanelGrid);
            app.ShipsSelectPanelThirdRow.ColumnWidth = {'1x'};
            app.ShipsSelectPanelThirdRow.RowHeight = {'1x', '1x', '1x'};
            app.ShipsSelectPanelThirdRow.ColumnSpacing = 0;
            app.ShipsSelectPanelThirdRow.Padding = [0 0 0 0];
            app.ShipsSelectPanelThirdRow.Layout.Row = 3;
            app.ShipsSelectPanelThirdRow.Layout.Column = 1;

            % Create RemoveAllAddedShipsButton
            app.RemoveAllAddedShipsButton = uibutton(app.ShipsSelectPanelThirdRow, 'push');
            app.RemoveAllAddedShipsButton.ButtonPushedFcn = createCallbackFcn(app, @RemoveAllAddedShipsButtonPushed, true);
            app.RemoveAllAddedShipsButton.WordWrap = 'on';
            app.RemoveAllAddedShipsButton.BackgroundColor = [0.6353 0.0784 0.1843];
            app.RemoveAllAddedShipsButton.FontSize = 14;
            app.RemoveAllAddedShipsButton.FontWeight = 'bold';
            app.RemoveAllAddedShipsButton.FontColor = [1 1 1];
            app.RemoveAllAddedShipsButton.Enable = 'off';
            app.RemoveAllAddedShipsButton.Layout.Row = 3;
            app.RemoveAllAddedShipsButton.Layout.Column = 1;
            app.RemoveAllAddedShipsButton.Text = 'Odebrat všechny přidané lodě';

            % Create RemoveLastAddedShipButton
            app.RemoveLastAddedShipButton = uibutton(app.ShipsSelectPanelThirdRow, 'push');
            app.RemoveLastAddedShipButton.ButtonPushedFcn = createCallbackFcn(app, @RemoveLastAddedShipButtonPushed, true);
            app.RemoveLastAddedShipButton.WordWrap = 'on';
            app.RemoveLastAddedShipButton.BackgroundColor = [0.9294 0.6941 0.1255];
            app.RemoveLastAddedShipButton.FontSize = 14;
            app.RemoveLastAddedShipButton.FontWeight = 'bold';
            app.RemoveLastAddedShipButton.FontColor = [1 1 1];
            app.RemoveLastAddedShipButton.Enable = 'off';
            app.RemoveLastAddedShipButton.Layout.Row = 2;
            app.RemoveLastAddedShipButton.Layout.Column = 1;
            app.RemoveLastAddedShipButton.Text = 'Odebrat poslední přidanou loď';

            % Create AddShipButton
            app.AddShipButton = uibutton(app.ShipsSelectPanelThirdRow, 'push');
            app.AddShipButton.ButtonPushedFcn = createCallbackFcn(app, @AddShipButtonPushed, true);
            app.AddShipButton.WordWrap = 'on';
            app.AddShipButton.BackgroundColor = [0.3922 0.8314 0.0745];
            app.AddShipButton.FontSize = 14;
            app.AddShipButton.FontWeight = 'bold';
            app.AddShipButton.FontColor = [1 1 1];
            app.AddShipButton.Enable = 'off';
            app.AddShipButton.Layout.Row = 1;
            app.AddShipButton.Layout.Column = 1;
            app.AddShipButton.Text = 'Přidat loď na herní desku';

            % Create ShipsSelectPanelSecondRow
            app.ShipsSelectPanelSecondRow = uigridlayout(app.ShipsSelectPanelGrid);
            app.ShipsSelectPanelSecondRow.ColumnWidth = {'1x', '1.5x'};
            app.ShipsSelectPanelSecondRow.RowHeight = {'1x', '1x', '1x'};
            app.ShipsSelectPanelSecondRow.Padding = [0 0 0 0];
            app.ShipsSelectPanelSecondRow.Layout.Row = 2;
            app.ShipsSelectPanelSecondRow.Layout.Column = 1;

            % Create PlayerBoardShipOrientationDropdown
            app.PlayerBoardShipOrientationDropdown = uidropdown(app.ShipsSelectPanelSecondRow);
            app.PlayerBoardShipOrientationDropdown.Items = {'Nahoru', 'Dolů', 'Doleva', 'Doprava'};
            app.PlayerBoardShipOrientationDropdown.Enable = 'off';
            app.PlayerBoardShipOrientationDropdown.FontSize = 14;
            app.PlayerBoardShipOrientationDropdown.FontWeight = 'bold';
            app.PlayerBoardShipOrientationDropdown.BackgroundColor = [1 1 1];
            app.PlayerBoardShipOrientationDropdown.Layout.Row = 3;
            app.PlayerBoardShipOrientationDropdown.Layout.Column = 2;
            app.PlayerBoardShipOrientationDropdown.Value = 'Nahoru';

            % Create PlayerBoardShipOrientationDropdownLabel
            app.PlayerBoardShipOrientationDropdownLabel = uilabel(app.ShipsSelectPanelSecondRow);
            app.PlayerBoardShipOrientationDropdownLabel.BackgroundColor = [1 1 1];
            app.PlayerBoardShipOrientationDropdownLabel.HorizontalAlignment = 'center';
            app.PlayerBoardShipOrientationDropdownLabel.FontSize = 14;
            app.PlayerBoardShipOrientationDropdownLabel.Enable = 'off';
            app.PlayerBoardShipOrientationDropdownLabel.Layout.Row = 3;
            app.PlayerBoardShipOrientationDropdownLabel.Layout.Column = 1;
            app.PlayerBoardShipOrientationDropdownLabel.Text = 'Orientace lodi';

            % Create PlayerBoardRowDropdown
            app.PlayerBoardRowDropdown = uidropdown(app.ShipsSelectPanelSecondRow);
            app.PlayerBoardRowDropdown.Enable = 'off';
            app.PlayerBoardRowDropdown.FontSize = 14;
            app.PlayerBoardRowDropdown.FontWeight = 'bold';
            app.PlayerBoardRowDropdown.BackgroundColor = [1 1 1];
            app.PlayerBoardRowDropdown.Layout.Row = 1;
            app.PlayerBoardRowDropdown.Layout.Column = 2;

            % Create PlayerBoardRowDropdownLabel
            app.PlayerBoardRowDropdownLabel = uilabel(app.ShipsSelectPanelSecondRow);
            app.PlayerBoardRowDropdownLabel.BackgroundColor = [1 1 1];
            app.PlayerBoardRowDropdownLabel.HorizontalAlignment = 'center';
            app.PlayerBoardRowDropdownLabel.FontSize = 14;
            app.PlayerBoardRowDropdownLabel.Enable = 'off';
            app.PlayerBoardRowDropdownLabel.Layout.Row = 1;
            app.PlayerBoardRowDropdownLabel.Layout.Column = 1;
            app.PlayerBoardRowDropdownLabel.Text = 'Řádek desky';

            % Create PlayerBoardColumnDropdown
            app.PlayerBoardColumnDropdown = uidropdown(app.ShipsSelectPanelSecondRow);
            app.PlayerBoardColumnDropdown.Enable = 'off';
            app.PlayerBoardColumnDropdown.FontSize = 14;
            app.PlayerBoardColumnDropdown.FontWeight = 'bold';
            app.PlayerBoardColumnDropdown.BackgroundColor = [1 1 1];
            app.PlayerBoardColumnDropdown.Layout.Row = 2;
            app.PlayerBoardColumnDropdown.Layout.Column = 2;

            % Create PlayerBoardColumnDropdownLabel
            app.PlayerBoardColumnDropdownLabel = uilabel(app.ShipsSelectPanelSecondRow);
            app.PlayerBoardColumnDropdownLabel.BackgroundColor = [1 1 1];
            app.PlayerBoardColumnDropdownLabel.HorizontalAlignment = 'center';
            app.PlayerBoardColumnDropdownLabel.FontSize = 14;
            app.PlayerBoardColumnDropdownLabel.Enable = 'off';
            app.PlayerBoardColumnDropdownLabel.Layout.Row = 2;
            app.PlayerBoardColumnDropdownLabel.Layout.Column = 1;
            app.PlayerBoardColumnDropdownLabel.Text = 'Sloupec desky';

            % Create ShipsListBox
            app.ShipsListBox = uilistbox(app.ShipsSelectPanelGrid);
            app.ShipsListBox.Items = {};
            app.ShipsListBox.ValueChangedFcn = createCallbackFcn(app, @ShipsListBoxValueChanged, true);
            app.ShipsListBox.Enable = 'off';
            app.ShipsListBox.FontSize = 14;
            app.ShipsListBox.FontWeight = 'bold';
            app.ShipsListBox.Layout.Row = 1;
            app.ShipsListBox.Layout.Column = 1;
            app.ShipsListBox.Value = {};

            % Create GameAreaTabFirstRow
            app.GameAreaTabFirstRow = uigridlayout(app.GameAreaTabGrid);
            app.GameAreaTabFirstRow.ColumnWidth = {'1x', '1.3x'};
            app.GameAreaTabFirstRow.RowHeight = {'1x'};
            app.GameAreaTabFirstRow.ColumnSpacing = 0;
            app.GameAreaTabFirstRow.RowSpacing = 0;
            app.GameAreaTabFirstRow.Padding = [0 0 0 0];
            app.GameAreaTabFirstRow.Layout.Row = 1;
            app.GameAreaTabFirstRow.Layout.Column = 1;

            % Create GameStatePanel
            app.GameStatePanel = uipanel(app.GameAreaTabFirstRow);
            app.GameStatePanel.TitlePosition = 'centertop';
            app.GameStatePanel.Title = 'STAV HRY';
            app.GameStatePanel.Layout.Row = 1;
            app.GameStatePanel.Layout.Column = 2;
            app.GameStatePanel.FontWeight = 'bold';
            app.GameStatePanel.FontSize = 24;

            % Create GameStatePanelGrid
            app.GameStatePanelGrid = uigridlayout(app.GameStatePanel);
            app.GameStatePanelGrid.ColumnWidth = {'1x'};
            app.GameStatePanelGrid.RowHeight = {'1x'};

            % Create Label_2
            app.Label_2 = uilabel(app.GameStatePanelGrid);
            app.Label_2.HorizontalAlignment = 'right';
            app.Label_2.FontWeight = 'bold';
            app.Label_2.Layout.Row = 1;
            app.Label_2.Layout.Column = 1;
            app.Label_2.Text = '';

            % Create GameStateTextArea
            app.GameStateTextArea = uitextarea(app.GameStatePanelGrid);
            app.GameStateTextArea.Editable = 'off';
            app.GameStateTextArea.FontSize = 36;
            app.GameStateTextArea.FontWeight = 'bold';
            app.GameStateTextArea.FontColor = [0 0 1];
            app.GameStateTextArea.BackgroundColor = [0.8 0.8 0.8];
            app.GameStateTextArea.Layout.Row = 1;
            app.GameStateTextArea.Layout.Column = 1;

            % Create GameMenuPanel
            app.GameMenuPanel = uipanel(app.GameAreaTabFirstRow);
            app.GameMenuPanel.TitlePosition = 'centertop';
            app.GameMenuPanel.Title = 'MENU HRY';
            app.GameMenuPanel.Layout.Row = 1;
            app.GameMenuPanel.Layout.Column = 1;
            app.GameMenuPanel.FontWeight = 'bold';
            app.GameMenuPanel.Scrollable = 'on';
            app.GameMenuPanel.FontSize = 24;

            % Create GameMenuPanelGrid
            app.GameMenuPanelGrid = uigridlayout(app.GameMenuPanel);
            app.GameMenuPanelGrid.ColumnWidth = {'1x'};
            app.GameMenuPanelGrid.ColumnSpacing = 0;
            app.GameMenuPanelGrid.RowSpacing = 20;

            % Create EndGameButton
            app.EndGameButton = uibutton(app.GameMenuPanelGrid, 'push');
            app.EndGameButton.ButtonPushedFcn = createCallbackFcn(app, @EndGameButtonPushed, true);
            app.EndGameButton.WordWrap = 'on';
            app.EndGameButton.BackgroundColor = [0.6353 0.0784 0.1843];
            app.EndGameButton.FontSize = 18;
            app.EndGameButton.FontWeight = 'bold';
            app.EndGameButton.FontColor = [1 1 1];
            app.EndGameButton.Enable = 'off';
            app.EndGameButton.Layout.Row = 2;
            app.EndGameButton.Layout.Column = 1;
            app.EndGameButton.Text = 'Ukonči hru';

            % Create StartGameButton
            app.StartGameButton = uibutton(app.GameMenuPanelGrid, 'push');
            app.StartGameButton.ButtonPushedFcn = createCallbackFcn(app, @StartGameButtonPushed, true);
            app.StartGameButton.WordWrap = 'on';
            app.StartGameButton.BackgroundColor = [0.302 0.4 0.9216];
            app.StartGameButton.FontSize = 18;
            app.StartGameButton.FontWeight = 'bold';
            app.StartGameButton.FontColor = [1 1 1];
            app.StartGameButton.Layout.Row = 1;
            app.StartGameButton.Layout.Column = 1;
            app.StartGameButton.Text = 'Zahaj hru';

            % Create MadeMovesHistoryTab
            app.MadeMovesHistoryTab = uitab(app.TabGroup);
            app.MadeMovesHistoryTab.Title = 'HISTORIE PROVEDENÝCH TAHŮ';

            % Create MadeMovesHistoryTabGrid
            app.MadeMovesHistoryTabGrid = uigridlayout(app.MadeMovesHistoryTab);
            app.MadeMovesHistoryTabGrid.ColumnWidth = {'1x'};
            app.MadeMovesHistoryTabGrid.RowHeight = {'1x'};

            % Create MadeMovesHistoryTextArea
            app.MadeMovesHistoryTextArea = uitextarea(app.MadeMovesHistoryTabGrid);
            app.MadeMovesHistoryTextArea.Editable = 'off';
            app.MadeMovesHistoryTextArea.FontSize = 24;
            app.MadeMovesHistoryTextArea.FontWeight = 'bold';
            app.MadeMovesHistoryTextArea.FontColor = [0 0 1];
            app.MadeMovesHistoryTextArea.BackgroundColor = [0.8 0.8 0.8];
            app.MadeMovesHistoryTextArea.Layout.Row = 1;
            app.MadeMovesHistoryTextArea.Layout.Column = 1;

            % Show the figure after all components are created
            app.BattleShipsGameUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = battleShipsGame

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.BattleShipsGameUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.BattleShipsGameUIFigure)
        end
    end
end