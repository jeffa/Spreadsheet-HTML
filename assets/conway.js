<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
<script type="text/javascript">
/*
Javascript Copyright 2015 Sandeep kumar H R
http://codereview.stackexchange.com/users/68298/sandeep-kumar-h-r
http://codereview.stackexchange.com/questions/85368/game-of-life-in-javascript-using-table
http://codepen.io/SrSandeepKumar/pen/bNZMyg
*/
(function(){
    $(document).ready(function(){
        var column = "", appendRow = "", inc = 1, selectedCells = [], toRemoveClass = [], toAddClass = [], maxValue;

        maxValue = %s;

        $("td").click( function(data){
            selectedCells.push(parseInt(this.id));
            $(this).addClass("valid");
        });

        var checkAgain = function(selectedCells){
            var check = 0, toBeReplaced = [], inArray = [], livingCell;
            var currentNumber = 0;
            var north, northEast, East, southEast, south, southWest, west, northWest;

            for(var i=0; i<selectedCells.length; i++){
                check = 0;
                currentNumber = parseInt(selectedCells[i]);

                if($("#"+(currentNumber)).hasClass("valid")){
                    livingCell = true;
                } else {
                    livingCell = false;
                }

                if(currentNumber > 0 && currentNumber < maxValue){
                
                    /*North*/
                    if((currentNumber-10) > 0 && (currentNumber-10) < maxValue){    
                        if($("#"+(currentNumber-10)).hasClass("valid")){
                            check ++;
                        }
                    }

                    /*North East*/
                    if((currentNumber-9) > 0 && (currentNumber-9) < maxValue){  
                        if($("#"+(currentNumber-9)).hasClass("valid")){
                            check ++;
                        }
                    }

                    /*East*/
                    if((currentNumber+1) > 0 && (currentNumber+1) < maxValue){  
                        if($("#"+(currentNumber+1)).hasClass("valid")){
                            check ++;
                        }
                    }

                    /*South East*/
                    if((currentNumber+11) > 0 && (currentNumber+11) < maxValue){    
                        if($("#"+(currentNumber+11)).hasClass("valid")){
                            check ++;
                        }
                    }

                    /*South*/
                    if((currentNumber+10) > 0 && (currentNumber+10) < maxValue){    
                        if($("#"+(currentNumber+10)).hasClass("valid")){
                            check ++;
                        }
                    }

                    /*South West*/
                    if((currentNumber+9) > 0 && (currentNumber+9) < maxValue){  
                        if($("#"+(currentNumber+9)).hasClass("valid")){
                            check ++;
                        }
                    }

                    /*West*/
                    if((currentNumber-1) > 0 && (currentNumber-1) < maxValue){  
                        if($("#"+(currentNumber-1)).hasClass("valid")){
                            check ++;
                        }
                    }

                    /*North West*/
                    if((currentNumber-11) > 0 && (currentNumber-11) < maxValue){    
                        if($("#"+(currentNumber-11)).hasClass("valid")){
                            check ++;
                        }
                    }

                    if(livingCell){
                        if(check === 0 || check === 1 ){
                            if(toRemoveClass.indexOf(currentNumber) == -1){
                                toRemoveClass.push(currentNumber);
                            }
                        } 
                        if(check == 4 || check == 5 || check == 6 || check == 7 || check == 8 ){
                            if(toRemoveClass.indexOf(currentNumber) == -1){
                                toRemoveClass.push(currentNumber);
                            }
                        } 
                        if(check == 2 || check == 3){
                            if(toAddClass.indexOf(currentNumber) == -1){
                                toAddClass.push(currentNumber);
                            }
                        } 
                    } else {
                        if(check == 3){
                            if(toAddClass.indexOf(currentNumber) == -1){
                                toAddClass.push(currentNumber);
                            }
                        } 
                    }

                }
            }
        };

        var gol = function(selectedCells){
            var check = 0, inArray = [];
             var currentNumber = 0, livingCell;
            for(var i=0; i<selectedCells.length; i++){
                    toBeReplaced = [];
                    check = 0;
                    currentNumber = parseInt(selectedCells[i]);

                    if($("#"+(currentNumber)).hasClass("valid")){
                        livingCell = true;
                    } else {
                        livingCell = false;
                    }
                    
                    if(currentNumber > 0 && currentNumber < maxValue){
                    
                        /*North*/
                        if((currentNumber-10) > 0 && (currentNumber-10) < maxValue){    
                            if($("#"+(currentNumber-10)).hasClass("valid")){
                                check ++;
                            }
                        
                            if(toBeReplaced.indexOf((currentNumber-10)) == -1){
                                toBeReplaced.push(currentNumber-10);
                            }
                        }

                        /*North East*/
                        if((currentNumber-9) > 0 && (currentNumber-9) < maxValue){  
                            if($("#"+(currentNumber-9)).hasClass("valid")){
                                check ++;
                            }
                        
                            if(toBeReplaced.indexOf((currentNumber-9)) == -1){
                                toBeReplaced.push(currentNumber-9);
                            }
                        }

                        /*East*/
                        if((currentNumber+1) > 0 && (currentNumber+1) < maxValue){  
                            if($("#"+(currentNumber+1)).hasClass("valid")){
                                check ++;
                            }

                            if(toBeReplaced.indexOf((currentNumber+1)) == -1){
                                toBeReplaced.push(currentNumber+1);
                            }
                        }

                        /*South East*/
                        if((currentNumber+11) > 0 && (currentNumber+11) < maxValue){    
                            if($("#"+(currentNumber+11)).hasClass("valid")){
                                check ++;
                            }

                            if(toBeReplaced.indexOf((currentNumber+11)) == -1){
                                toBeReplaced.push(currentNumber+11);
                            }
                        }

                        /*South*/
                        if((currentNumber+10) > 0 && (currentNumber+10) < maxValue){    
                            if($("#"+(currentNumber+10)).hasClass("valid")){
                                check ++;
                            }

                            if(toBeReplaced.indexOf((currentNumber+10)) == -1){
                                toBeReplaced.push(currentNumber+10);
                            }
                        }

                        /*South West*/
                        if((currentNumber+9) > 0 && (currentNumber+9) < maxValue){  
                            if($("#"+(currentNumber+9)).hasClass("valid")){
                                check ++;
                            }

                            if(toBeReplaced.indexOf((currentNumber+9)) == -1){
                                toBeReplaced.push(currentNumber+9);
                            }
                        }

                        /*West*/
                        if((currentNumber-1) > 0 && (currentNumber-1) < maxValue){  
                            if($("#"+(currentNumber-1)).hasClass("valid")){
                                check ++;
                            }

                            if(toBeReplaced.indexOf((currentNumber-1)) == -1){
                                toBeReplaced.push(currentNumber-1);
                            }
                        }

                        /*North West*/
                        if((currentNumber-11) > 0 && (currentNumber-11) < maxValue){    
                            if($("#"+(currentNumber-11)).hasClass("valid")){
                                check ++;
                            }

                            if(toBeReplaced.indexOf((currentNumber-11)) == -1){
                                toBeReplaced.push(currentNumber-11);
                            }
                        }

                        if(livingCell){
                            if(check == 0 || check == 1 ){
                                if(toRemoveClass.indexOf(currentNumber) == -1){
                                    toRemoveClass.push(currentNumber);
                                }
                            } 
                            if(check == 4 || check == 5 || check == 6 || check == 7 || check == 8 ){
                                if(toRemoveClass.indexOf(currentNumber) == -1){
                                    toRemoveClass.push(currentNumber);
                                }
                            } 
                            if(check == 2 || check == 3){
                                if(toAddClass.indexOf(currentNumber) == -1){
                                    toAddClass.push(currentNumber);
                                }
                            } 
                        } else {
                            if(check == 3){
                                if(toAddClass.indexOf(currentNumber) == -1){
                                    toAddClass.push(currentNumber);
                                }
                            } 
                        }

                    }
                checkAgain(toBeReplaced);
            }
            
            for(var i=0; i<toRemoveClass.length; i++){
                $("#"+toRemoveClass[i]).removeClass("valid");
            }
            
            for(var i=0; i<toAddClass.length; i++){
                $("#"+toAddClass[i]).addClass("valid");
            }
            
            toBeReplaced = toAddClass;  
            
            if(toAddClass.length == 0){
                //exit
                return;
            } else {
                setInterval(function(){
                    gol($.unique(toBeReplaced));
                },1000);
            }
    
            selectedCells = [];
            toAddClass =[];
            toRemoveClass = [];
    
        };

        start = function(){
            if(selectedCells.length == 0){
                alert("select cell");
            } else {
                gol(selectedCells);
            }
        };
    });
})();
</script>
