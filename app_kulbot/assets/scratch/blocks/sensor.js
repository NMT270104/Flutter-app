'use strict';

Blockly.defineBlocksWithJsonArray([


    {
        'type': 'get_tem',
        'message0':'Get Temperature: Port %1 (˚C)',
        'args0':[
            {
                'type': 'field_dropdown',
                'name': 'get_temp_port',
                'options': [
                    [
                        "1",
                        "1"
                      ],
                      [
                        "2",
                        "2"
                      ],
                      [
                        "3",
                        "3"
                      ],
                      [
                        "4",
                        "4"
                      ],
                      [
                        "5",
                        "5"
                      ],
                      [
                        "6",
                        "6"
                      ],
                      [
                        "7",
                        "7"
                      ],
                      [
                        "8",
                        "8"
                      ]
                ]
            }
        ],
        'output':'Float',
        "colour": 230,
    },
    {
        'type': 'get_hum',
        'message0':'Get Hum: Port %1 (%)',
        'args0':[
            {
                'type': 'field_dropdown',
                'name': 'get_hum_port',
                'options': [
                    [
                        "1",
                        "1"
                      ],
                      [
                        "2",
                        "2"
                      ],
                      [
                        "3",
                        "3"
                      ],
                      [
                        "4",
                        "4"
                      ],
                      [
                        "5",
                        "5"
                      ],
                      [
                        "6",
                        "6"
                      ],
                      [
                        "7",
                        "7"
                      ],
                      [
                        "8",
                        "8"
                      ]
                ]
            }
        ],
        'output':'Float',
        "colour": 230,
    },
 

]);