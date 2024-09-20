'use strict';


Blockly.defineBlocksWithJsonArray([

    {
        "type": "wait_seconds",
        "message0": "wait %1 seconds",
        "inputsInline": true,
        "args0": [
          {
            "type": "input_value",
            "name": "TIMEOUT",
            "check": "Number",
          }
        ],
        "previousStatement": null,
        "nextStatement": null,
        "colour": 120
    },
    {
        "type": "controls_repeat",
        "message0": "repeat %1 ",
        "args0": [
          {
            "type": "input_value",
            "name": "TIMES",
            "check": "Number"
          }
        ],
        "message1": "%1",
        "args1": [
          {
            "type": "input_statement",
            "name": "DO"
          }
        ],
        "previousStatement": null,
        "nextStatement": null,
        "colour": 120,
        "tooltip": "Lặp lại một hành động nhiều lần.",
      },
      {
        "type": "controls_forever",
        "message0": "forever",
        
        "message1": "%1",
        "args1": [
          {
            "type": "input_statement",
            "name": "DO"
          }
        ],
        'args2': [],
        "previousStatement": null,
        // "nextStatement": false,
        "colour": 120,
        "tooltip": "Lặp lại một hành động nhiều lần.",
      }
    ,
    {
        "type": "wait_until",
        "message0": "wait until %1 ",
        "args0": [
          {
            "type": "input_value",
            "name": "wait_until_boolean",
            "check": "Boolean"
          }
        ],
        "previousStatement": null,
        "nextStatement": null,
        "colour": 120,
        "tooltip": "Lặp lại một hành động nhiều lần.",
      }
      ,
      {
        "type": "controls_repeat_until",
        "message0": "repeat until %1 ",
        "args0": [
          {
            "type": "input_value",
            "name": "repeat_until_boolean",
            "check": "Boolean",   

          }
        ],
        "message1": "%1",
        "args1": [
          {
            "type": "input_statement",
            "name": "DO"
          }
        ],
        "previousStatement": null,
        "nextStatement": null,
        "colour": 120,
        "tooltip": "Lặp lại một hành động nhiều lần.",
      },
      

]);