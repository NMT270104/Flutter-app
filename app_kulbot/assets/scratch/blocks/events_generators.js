'use strict';


Blockly.defineBlocksWithJsonArray([
    {
        "type": "event_program_starts",
        "message0": "when program starts",
        //"message1": "%1",
        "args1": [
          {"type": "input_statement", "name": "DO", "flip_rtl": true}
        ],
        "colour": 120,
        "nextStatement": true,
      }
      ,
      {
        "type": "event_repeat_forever",
        "message0": "repeat forever",
        "message1": "%1",
        "args1": [
          {"type": "input_statement", "name": "DO"}
        ],
        "previousStatement": null,
        "nextStatement": null,
        "colour": 120,
        "tooltip": "",
        "helpUrl": ""
      }
    ,
      {
        "type": "event_repeat_timer",
        "message0": "repeat every %1 milliseconds",
        "inputsInline": true,
        "args0": [
          {
            "type": "input_value",
            "name": "PERIOD",
            "check": "Number"
          }
        ],
        "message1": "%1",
        "args1": [
          {"type": "input_statement", "name": "DO"}
        ],
        "colour": 65
      }
       ,
      {
        "type": "event_wait",
        "message0": "wait %1 milliseconds",
        "inputsInline": true,
        "args0": [
          {
            "type": "input_value",
            "name": "TIMEOUT",
            "check": "Number"
          }
        ],
        "previousStatement": "Action",
        "nextStatement": "Action",
        "colour": 120
      }
      ,
      {
        "type": "logic_boolean_workaround",
        "message0": "\u00A0%1",
        "args0": [
          {
            "type": "field_dropdown",
            "name": "BOOL",
            "options": [
              ["true", "TRUE"],
              ["false", "FALSE"]
            ]
          }
        ],
        "output": "Boolean",
        "colour": "210"
      }
  ]);

  sampleGenerator.forBlock['event_program_starts'] = function(block, generator) {
    return 'my code string';
  };

  // Blockly.JavaScript['event_program_starts'] = function(block) {
  //   var nextCode = Blockly.JavaScript.statementToCode(block, 'DO');
  //   var code = 'while(true) {\n' +
  //               nextCode + '\n' +
  //               'if(Turtle.isStop() == true){break;}\n' +
  //             '}; Turtle.MF(0);\n';
  //   return code;
  // };

  // Khối event_program_starts
// Blockly.Dart['event_program_starts'] = function(block) {
//   var statements_do = Blockly.Dart.statementToCode(block, 'DO');
//   var code = 'void startProgram() {\n' + statements_do + '\n}\n';
//   return code;
// };

// Khối event_repeat_forever
Blockly.Dart['event_repeat_forever'] = function(block) {
  var statements_do = Blockly.Dart.statementToCode(block, 'DO');
  var code = 'while (true) {\n' + statements_do + '\n}\n';
  return code;
};

// Khối event_repeat_timer
Blockly.Dart['event_repeat_timer'] = function(block) {
  var period = Blockly.Dart.valueToCode(block, 'PERIOD', Blockly.Dart.ORDER_ATOMIC) || '500';
  var statements_do = Blockly.Dart.statementToCode(block, 'DO');
  var code = 'Timer.periodic(Duration(milliseconds: ' + period + '), (timer) {\n' + statements_do + '\n});\n';
  return code;
};

// Khối event_wait
Blockly.Dart['event_wait'] = function(block) {
  var timeout = Blockly.Dart.valueToCode(block, 'TIMEOUT', Blockly.Dart.ORDER_ATOMIC) || '500';
  var code = 'await Future.delayed(Duration(milliseconds: ' + timeout + '));\n';
  return code;
};

// Khối logic_boolean_workaround
Blockly.Dart['logic_boolean_workaround'] = function(block) {
  var code = (block.getFieldValue('BOOL') == 'TRUE') ? 'true' : 'false';
  return [code, Blockly.Dart.ORDER_ATOMIC];
};



// Blockly.JavaScript['event_repeat_forever'] = function(block) {
//     var nextCode = Blockly.JavaScript.statementToCode(block, 'DO');
//     return 'while(true) {\n' +
//                 nextCode+'\n' +
//                 "if(Turtle.isStop() == true){break;}\n"+
//             '}; Turtle.MF(0);\n';
// };

// Blockly.JavaScript['event_repeat_timer'] = function(block) {
//     var period = Blockly.JavaScript.valueToCode(block, 'PERIOD', Blockly.JavaScript.ORDER_FUNCTION_CALL) || 500

//     var nextCode = Blockly.JavaScript.statementToCode(block, 'DO');
//     return "setInterval(() => {\n"+nextCode+"\n}, "+period+");"
// };

// Blockly.JavaScript['event_wait'] = function(block) {
//     // Terrible implementation of wait for the moment
//     var timeout = Blockly.JavaScript.valueToCode(block, 'TIMEOUT', Blockly.JavaScript.ORDER_FUNCTION_CALL) || 500
// //    var nextBlock = block.nextConnection && block.nextConnection.targetBlock();
// //    var nextCode = Blockly.JavaScript.blockToCode(nextBlock);
// //    // And then remove the next block from code generation
// //    block.nextConnection = null;
// //    var functionName = Blockly.JavaScript.provideFunction_(
// //          'timer',
// //          ['function ' + Blockly.JavaScript.FUNCTION_NAME_PLACEHOLDER_ +
// //              '(ms) {',
// //           '  return new Promise(res => setTimeout(res, ms));',
// //           '}']);
// //    var functionName = Blockly.JavaScript.provideFunction_(
// //             'sleep',
// //             ['async function ' + Blockly.JavaScript.FUNCTION_NAME_PLACEHOLDER_ +
// //                 '(ms) {',
// //              '  await timer(ms);',
// //              '}']);
// //    return "sleep("+timeout+");\n"+nextCode
//     return  "let d = Date.now();\n"+
//             "do {}\n"+
//             "while(Date.now()-d < "+timeout+");\n"
// };

// Blockly.JavaScript['logic_boolean_workaround'] = function(block) {
//     var code = (block.getFieldValue('BOOL') == 'TRUE') ? 'true' : 'false';
//     return [code, Blockly.JavaScript.ORDER_ATOMIC];
// };



