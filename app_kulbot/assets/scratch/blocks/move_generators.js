'use strict';
         //sound sensor
         Blockly.JavaScript['sound_sensor'] = function(block) {
           var dropdown_sound_port = block.getFieldValue('sound_port');
           // TODO: Assemble JavaScript into code variable.
           return [dropdown_sound_port, Blockly.JavaScript.ORDER_NONE];;
         };

        //touch sensor
        Blockly.JavaScript['touch_sensor'] = function(block) {
          var dropdown_touch_port = block.getFieldValue('touch_port');
          // TODO: Assemble JavaScript into code variable.

          // TODO: Change ORDER_NONE to the correct strength.
          return [dropdown_touch_port, Blockly.JavaScript.ORDER_NONE];
        };

        //avoid sensor
                Blockly.JavaScript['avoid_sensor'] = function(block) {
                  var dropdown_avoid_port = block.getFieldValue('avoid_port');
                  // TODO: Assemble JavaScript into code variable.

                  // TODO: Change ORDER_NONE to the correct strength.
                  return [dropdown_avoid_port, Blockly.JavaScript.ORDER_NONE];
                };

        Blockly.JavaScript['line_follow2'] = function(block) {
          var dropdown_line_port = block.getFieldValue('line_port');
          var dropdown_side = block.getFieldValue('side');
          var dropdown_color = block.getFieldValue('color');
          // TODO: Assemble JavaScript into code variable.
        var code = "Turtle.lineFollow2(\'"+dropdown_line_port+"\',\'"+dropdown_side+"\',\'"+dropdown_color+"\')\n";
          return [code, Blockly.JavaScript.ORDER_NONE];
        };


        //light sensor
        Blockly.JavaScript['light_sensor'] = function(block) {
          var dropdown_name = block.getFieldValue('NAME');
          // TODO: Assemble JavaScript into code variable.
           var code = "Turtle.lightSensor(\'"+ dropdown_name+"\');\n";
              return [dropdown_name, Blockly.JavaScript.ORDER_NONE];
        };
       //temperature
        Blockly.JavaScript['temperature_tit'] = function(block) {
          var dropdown_tem_port = block.getFieldValue('tem_port');
          // TODO: Assemble JavaScript into code variable.
          var code ="Turtle.temperature(\'"+dropdown_tem_port+"\')";
          return [code, Blockly.JavaScript.ORDER_NONE];
        };
        //pontel

                        Blockly.JavaScript['potenl_tit'] = function(block) {
                             var dropdown_tem_port = block.getFieldValue('potenl_port');
                             // TODO: Assemble JavaScript into code variable.
                             var code ="Turtle.potenl(\'"+dropdown_tem_port+"\')";
                             return [code, Blockly.JavaScript.ORDER_NONE];
                           };
      //servo
      Blockly.JavaScript['ms_servo'] = function(block) {
        var dropdown_port_servo = block.getFieldValue('port_servo');
        var number_angle_servo = block.getFieldValue('angle_servo');
        var number_durations_servo = block.getFieldValue('durations_servo');
        // TODO: Assemble JavaScript into code variable.
        var code = "Turtle.mAFServo(\'"+dropdown_port_servo+"\',"+number_angle_servo+","+ number_durations_servo+");\n  sleep(10); \n if(Turtle.isStop() == true){break;}\n";
        return code;
      };
      Blockly.JavaScript['servo_no'] = function(block) {
        var dropdown_portsv = block.getFieldValue('portSV');
        var number_angle_sv = block.getFieldValue('angle_sv');
        // TODO: Assemble JavaScript into code variable.
        var code = "Turtle.servo_no(\'"+dropdown_portsv+"\',"+number_angle_sv+"); \n if(Turtle.isStop() == true){break;}\n";
        return code;
      };

     //wait
     Blockly.JavaScript['wait'] = function(block) {
       var number_name = block.getFieldValue('NAME');
       // TODO: Assemble JavaScript into code variable.
       return "sleep("+number_name+");";
     };

// Motor m1, m2:

Blockly.JavaScript['movem1m2'] = function(block) {
  var number_speed1 = block.getFieldValue('speed1');
  var number_speed2 = block.getFieldValue('speed2');
  // TODO: Assemble JavaScript into code variable.
  var code = "Turtle.movem1m2("+number_speed1+","+number_speed2+");\n if(Turtle.isStop() == true){break;}\n";
  return code;
};


    //compare
  Blockly.JavaScript['compare'] = function(block) {
    var value_number1 = Blockly.JavaScript.valueToCode(block, 'number1', Blockly.JavaScript.ORDER_ATOMIC);
    var dropdown_dropdown = block.getFieldValue('dropdown');
    var value_number2 = Blockly.JavaScript.valueToCode(block, 'number2', Blockly.JavaScript.ORDER_ATOMIC);
    // TODO: Assemble JavaScript into code variable.
    var code = value_number1 + dropdown_dropdown + value_number2;
    // TODO: Change ORDER_NONE to the correct strength.
    return [code, Blockly.JavaScript.ORDER_NONE];
  };
  // untra
   Blockly.JavaScript['ultrasonic_port'] = function(block) {
  var dropdown_ul_port = block.getFieldValue('Ul_Port');
  // TODO: Assemble JavaScript into code variable.
  var code = dropdown_ul_port  ;
// TODO: Change ORDER_NONE to the correct strength.
  return [code , Blockly.JavaScript.ORDER_NONE];
    };


// Extensions to Blockly's language and JavaScript generator.
Blockly.JavaScript['turtle_move_internal'] = function(block) {
  // Generate JavaScript for moving forward or backwards.
  var value = block.getFieldValue('VALUE');
 return 'Turtle.' + block.getFieldValue('DIR') +
       '(' + value + ', \'block_id_' + block.id + '\');\n if(Turtle.isStop() == true){break;}\n';
};

Blockly.JavaScript['turtle_repeat_internal'] = Blockly.JavaScript['controls_repeat'];


/**
 * The generated code for turtle blocks includes block ID strings.  These are useful for
 * highlighting the currently running block, but that behaviour is not supported in Android Blockly
 * as of May 2016.  This snippet generates the block code normally, then strips out the block IDs
 * for readability when displaying the code to the user.
 *
 * Post-processing the block code in this way allows us to use the same generators for the Android
 * and web versions of the turtle.
 */
Blockly.JavaScript.workspaceToCodeWithId = Blockly.JavaScript.workspaceToCode;

Blockly.JavaScript.workspaceToCode = function(workspace) {
  var code = this.workspaceToCodeWithId(workspace);
  // Strip out block IDs for readability.
  code = goog.string.trimRight(code.replace(/(,\s*)?'block_id_[^']+'\)/g, ')'))
  return code;
};
