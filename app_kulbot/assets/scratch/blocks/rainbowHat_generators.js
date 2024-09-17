'use strict';

Blockly.defineBlocksWithJsonArray([
    {
        "type": "rainbow_hat_button_action",
        "message0": "when %1 is %2",
        "args0": [
          {
            "type": "field_dropdown",
            "name": "BUTTON",
            "options": [
              [ "Button A", "BUTTON_A" ],
              [ "Button B", "BUTTON_B" ],
              [ "Button C", "BUTTON_C" ]
            ]
          },
          {
            "type": "field_dropdown",
            "name": "STATE",
            "options": [
              [ "pressed", "BUTTON_PRESSED" ],
              [ "released", "BUTTON_RELEASED" ],
              [ "changed", "BUTTON_CHANGED" ]
            ]
          }
        ],
        "message1": "%1",
        "args1": [
          {"type": "input_statement", "name": "DO"}
        ],
        "colour": 290
      }
    ,
      {
        "type": "rainbow_hat_read_button",
        "message0": "is %1 pressed",
        "output": "Boolean",
        "args0": [
          {
            "type": "field_dropdown",
            "name": "BUTTON",
            "options": [
              [ "Button A", "BUTTON_A" ],
              [ "Button B", "BUTTON_B" ],
              [ "Button C", "BUTTON_C" ]
            ]
          }
        ],
        "colour": 290
      }
    ,
      {
        "type": "rainbow_hat_set_led_value",
        "message0": "set %1 LED to %2",
        "args0": [
          {
            "type": "field_dropdown",
            "name": "LED",
            "options": [
              [ "Red", "LED_RED" ],
              [ "Green", "LED_GREEN" ],
              [ "Blue", "LED_BLUE" ]
            ]
          },
          {
            "type": "input_value",
            "name": "VALUE",
            "check": "Boolean"
          }
        ],
        "previousStatement": "Action",
        "nextStatement": "Action",
        "colour": 290
      }
    ,
      {
        "type": "rainbow_hat_read_led",
        "message0": "state of %1 LED",
        "output": "Boolean",
        "args0": [
          {
            "type": "field_dropdown",
            "name": "LED",
            "options": [
              [ "Red", "LED_RED" ],
              [ "Green", "LED_GREEN" ],
              [ "Blue", "LED_BLUE" ]
            ]
          }
        ],
        "colour": 290
      }
    ,
      {
        "type": "rainbow_hat_display_text",
        "inputsInline": true,
        "message0": "display text %1 on LCD",
        "args0": [
          {
            "type": "input_value",
            "name": "VALUE",
            "check": "String"
          }
        ],
        "previousStatement": "Action",
        "nextStatement": "Action",
        "colour": 290
      }
    ,
      {
        "type": "rainbow_hat_display_number",
        "inputsInline": true,
        "message0": "display number %1 on LCD",
        "args0": [
          {
            "type": "input_value",
            "name": "VALUE",
            "check": "Float"
          }
        ],
        "previousStatement": "Action",
        "nextStatement": "Action",
        "colour": 290
      }
    ,
      {
        "type": "rainbow_hat_read_temperature",
        "message0": "temperature",
        "output": "Float",
        "colour": 290
      }
    ,
      {
        "type": "rainbow_hat_read_pressure",
        "message0": "pressure",
        "output": "Float",
        "colour": 290
      }
    ,
      {
        "type": "rainbow_hat_play",
        "message0": "play %1 frequency",
        "inputsInline": true,
        "args0": [
          {
            "type": "input_value",
            "name": "VALUE",
            "check": ["Double", "Float", "Integer", "Number"]
          }
        ],
        "previousStatement": "Action",
        "nextStatement": "Action",
        "colour": 290
      }
    ,
      {
        "type": "rainbow_hat_stop_playing",
        "message0": "stop playing",
        "previousStatement": "Action",
        "nextStatement": "Action",
        "colour": 290
      }
    ,
      {
        "type": "rainbow_hat_write_led_strip",
        "message0": "display colors %1 %2 %3 %4 %5 %6 %7",
        "args0": [
          {
            "type": "field_colour",
            "name": "COLOR1",
            "colour": "#ff0000"
          },
          {
            "type": "field_colour",
            "name": "COLOR2",
            "colour": "#ff0000"
          }
        ,
          {
            "type": "field_colour",
            "name": "COLOR3",
            "colour": "#ff0000"
          }
        ,
          {
            "type": "field_colour",
            "name": "COLOR4",
            "colour": "#ff0000"
          }
        ,
          {
            "type": "field_colour",
            "name": "COLOR5",
            "colour": "#ff0000"
          }
        ,
          {
            "type": "field_colour",
            "name": "COLOR6",
            "colour": "#ff0000"
          }
        ,
          {
            "type": "field_colour",
            "name": "COLOR7",
            "colour": "#ff0000"
          }
        ],
        "inputsInline": true,
        "previousStatement": "Action",
        "nextStatement": "Action",
        "colour": 290
      }
    ,
      {
        "type": "rainbow_hat_write_led_strip_array",
        "message0": "display colors %1",
        "inputsInline": true,
        "args0": [
          {
            "type": "input_value",
            "name": "COLORS",
            "check": "Array"
          }
        ],
        "inputsInline": true,
        "previousStatement": "Action",
        "nextStatement": "Action",
        "colour": 290
      }
    ,
      {
        "type": "rainbow_hat_write_led_strip_variables",
        "message0": "display colors %1 %2 %3 %4 %5 %6 %7",
        "inputsInline": true,
        "args0": [
          {
            "type": "input_value",
            "name": "COLOR1",
            "check": "Colour"
          },
          {
            "type": "input_value",
            "name": "COLOR2",
            "check": "Colour"
          }
        ,
          {
            "type": "input_value",
            "name": "COLOR3",
            "check": "Colour"
          }
        ,
          {
            "type": "input_value",
            "name": "COLOR4",
            "check": "Colour"
          }
        ,
          {
            "type": "input_value",
            "name": "COLOR5",
            "check": "Colour"
          }
        ,
          {
            "type": "input_value",
            "name": "COLOR6",
            "check": "Colour"
          }
        ,
          {
            "type": "input_value",
            "name": "COLOR7",
            "check": "Colour"
          }
        ],
        "inputsInline": true,
        "previousStatement": "Action",
        "nextStatement": "Action",
        "colour": 290
      }
]);2


Blockly.JavaScript['rainbow_hat_button_action'] = function(block) {
    var button = Blockly.JavaScript.variableDB_.getName(block.getFieldValue('BUTTON'), Blockly.Variables.NAME_TYPE);
    var buttonName = 'A';
    if (button == "BUTTON_A") {
        buttonName = 'A';
    }
    else if (button == "BUTTON_B") {
        buttonName = 'B';
    }
    else if (button == "BUTTON_C") {
        buttonName = 'C';
    }

    var state = Blockly.JavaScript.variableDB_.getName(block.getFieldValue('STATE'), Blockly.Variables.NAME_TYPE);
    var buttonState = 'Pressed';
    if (state == "BUTTON_PRESSED") {
        buttonState = 'Pressed';
    }
    else if (state == "BUTTON_RELEASED") {
        buttonState = 'Released';
    }
    else if (state == "BUTTON_CHANGED") {
        buttonState = 'Changed';
    }

    var nextCode = Blockly.JavaScript.statementToCode(block, 'DO');
    return 'function onButton'+buttonName+buttonState+'() {\n' +
                          nextCode+'\n' +
                          '}\n';
};

Blockly.JavaScript['rainbow_hat_read_button'] = function(block) {
    var button = Blockly.JavaScript.variableDB_.getName(block.getFieldValue('BUTTON'), Blockly.Variables.NAME_TYPE);
    var buttonName = 'A';
    if (button == "BUTTON_A") {
        buttonName = 'A';
    }
    else if (button == "BUTTON_B") {
        buttonName = 'B';
    }
    else if (button == "BUTTON_C") {
        buttonName = 'C';
    }
    return ["Android.getStateButton"+buttonName+"()", Blockly.JavaScript.ORDER_NONE];
};

Blockly.JavaScript['rainbow_hat_read_led'] = function(block) {
    var led = Blockly.JavaScript.variableDB_.getName(block.getFieldValue('LED'), Blockly.Variables.NAME_TYPE);
    var ledName = 'Red';
    if (led == "LED_RED") {
        ledName = 'Red';
    }
    else if (led == "LED_GREEN") {
        ledName = 'Green';
    }
    else {
        ledName = 'Blue';
    }
    return ["Android.getStateLed"+ledName+"()", Blockly.JavaScript.ORDER_NONE];
};


Blockly.JavaScript['rainbow_hat_set_led_value'] = function(block) {
    var led = Blockly.JavaScript.variableDB_.getName(block.getFieldValue('LED'), Blockly.Variables.NAME_TYPE);
    var pressed = Blockly.JavaScript.valueToCode(block, 'VALUE', Blockly.JavaScript.ORDER_FUNCTION_CALL) || 'true'
    if (led == "LED_RED") {
        return 'Android.setRedLed('+pressed+');';
    }
    else if (led == "LED_GREEN") {
        return 'Android.setGreenLed('+pressed+');';
    }
    else {
        return 'Android.setBlueLed('+pressed+');';
    }
};

Blockly.JavaScript['rainbow_hat_display_text'] = function(block) {
    var text = Blockly.JavaScript.valueToCode(block, 'VALUE', Blockly.JavaScript.ORDER_FUNCTION_CALL) || "''"
    return 'AlphanumericDisplay.displayText('+text+');\n';
};

Blockly.JavaScript['rainbow_hat_display_number'] = function(block) {
    var number = Blockly.JavaScript.valueToCode(block, 'VALUE', Blockly.JavaScript.ORDER_FUNCTION_CALL) || 0.0
    return 'AlphanumericDisplay.displayNumber('+number+');\n';
};

Blockly.JavaScript['rainbow_hat_read_temperature'] = function(block) {
    return ["Bmx280.readTemperature()", Blockly.JavaScript.ORDER_NONE];
};

Blockly.JavaScript['rainbow_hat_read_pressure'] = function(block) {
    return ["Bmx280.readPressure()", Blockly.JavaScript.ORDER_NONE];
};

Blockly.JavaScript['rainbow_hat_play'] = function(block) {
    var frequency = Blockly.JavaScript.valueToCode(block, 'VALUE', Blockly.JavaScript.ORDER_FUNCTION_CALL) || "0.0"
    return 'Speaker.play('+frequency+');';
};

Blockly.JavaScript['rainbow_hat_stop_playing'] = function(block) {
    return 'Speaker.stop();';
};

Blockly.JavaScript['rainbow_hat_write_led_strip'] = function(block) {
    return '{\n'+
            'let colors = [\n'+
            block.getFieldValue('COLOR1').replace('#','0x')+',\n'+
            block.getFieldValue('COLOR2').replace('#','0x')+',\n'+
            block.getFieldValue('COLOR3').replace('#','0x')+',\n'+
            block.getFieldValue('COLOR4').replace('#','0x')+',\n'+
            block.getFieldValue('COLOR5').replace('#','0x')+',\n'+
            block.getFieldValue('COLOR6').replace('#','0x')+',\n'+
            block.getFieldValue('COLOR7').replace('#','0x')+'\n'+
            '];\n'+
            'Apa102.write(colors);\n'+
            '}';
};

Blockly.JavaScript['rainbow_hat_write_led_strip_array'] = function(block) {
    var colorsArray = Blockly.JavaScript.valueToCode(block, 'COLORS', Blockly.JavaScript.ORDER_FUNCTION_CALL) || "[]";
    return  '{\n'+
            'let colors = [];\n'+
            'for (let i = 0; i < '+colorsArray+'.length; i++) {\n'+
            '   colors[i] = parseInt('+colorsArray+'[i].replace(\"#\",\"0x\"));\n'+
            '}\n'+
            'Apa102.write(colors);\n'+
            '}';
};