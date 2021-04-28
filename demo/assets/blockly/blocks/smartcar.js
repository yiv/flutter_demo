'use strict';

goog.provide('Blockly.Blocks.logic');  // Deprecated
goog.provide('Blockly.Constants.Logic');

goog.require('Blockly');
goog.require('Blockly.Blocks');
goog.require('Blockly.FieldDropdown');
goog.require('Blockly.FieldLabel');
goog.require('Blockly.Mutator');

Blockly.Constants.Logic.HUE = 210;



Blockly.defineBlocksWithJsonArray([  
  
  {
  "type": "robot_motion",
  "message0": "speed %1 Rad %2 %3",
  "args0": [
    {
      "type": "field_input",
      "name": "speed",
      "text": "0"
    },
    {
      "type": "field_input",
      "name": "rad",
      "text": "0"
    },
    {
      "type": "input_value",
      "name": "speed_rad",
      "check": "Number"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 120,
  "tooltip": "set speed and rad",
  "helpUrl": "www.help.com"
},
 {
  "type": "time",
  "message0": "time %1 %2",
  "args0": [
    {
      "type": "field_input",
      "name": "time",
      "text": "0"
    },
    {
      "type": "input_value",
      "name": "Time",
      "check": "Number"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 120,
  "tooltip": "set time cap",
  "helpUrl": "www.help.com"
},
 {
  "type": "led",
  "message0": "locate: %1 color: %2 state: %3 %4",
  "args0": [
    {
      "type": "field_dropdown",
      "name": "FB",
      "options": [
        [
          "Front",
          "F"
        ],
        [
          "Back",
          "B"
        ]
      ]
    },
    {
      "type": "field_dropdown",
      "name": "GR",
      "options": [
        [
          "Green",
          "G"
        ],
        [
          "Red",
          "R"
        ]
      ]
    },
    {
      "type": "field_dropdown",
      "name": "OC",
      "options": [
        [
          "Open",
          "O"
        ],
        [
          "Close",
          "C"
        ]
      ]
    },
    {
      "type": "input_value",
      "name": "led_state"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 120,
  "tooltip": "set time cap",
  "helpUrl": "www.help.com"
},
{
  "type": "while_do",
  "message0": "while %1 do %2",
  "args0": [
    {
      "type": "input_statement",
      "name": "while"
    },
    {
      "type": "input_statement",
      "name": "do"
    }
  ],
  "colour": 120,
  "tooltip": "set time cap",
  "helpUrl": "www.help.com"
},
{
  "type": "car_init",
  "message0": "car init",
  "previousStatement": null,
  "nextStatement": null,
  "colour": 120,
  "tooltip": "",
  "helpUrl": ""
},

{
  "type": "led_init",
  "message0": "led init",
  "previousStatement": null,
  "nextStatement": null,
  "colour": 120,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "led_deinit",
  "message0": "led deinit",
  "previousStatement": null,
  "nextStatement": null,
  "colour": 120,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "led_block",
  "message0": "LED %1 %2 0~100 %3",
  "args0": [
    {
      "type": "field_dropdown",
      "name": "NAME1",
      "options": [
        [
          "FrontGreen",
          "FG"
        ],
        [
          "FrontRed",
          "FR"
        ],
        [
          "BackGreen",
          "BG"
        ],
        [
          "BackRed",
          "BR"
        ]
      ]
    },
    {
      "type": "field_dropdown",
      "name": "NAME2",
      "options": [
        [
          "0",
          "0"
        ],
        [
          "1",
          "1"
        ]
      ]
    },
    {
      "type": "field_input",
      "name": "Value",
      "text": "0"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 150,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "led_block_f",
  "message0": "LED %1 %2",
  "args0": [
    {
      "type": "field_dropdown",
      "name": "NAME1",
      "options": [
        [
          "FrontGreen",
          "FG"
        ],
        [
          "FrontRed",
          "FR"
        ]
      ]
    },
    {
      "type": "field_dropdown",
      "name": "NAME2",
      "options": [
        [
          "0",
          "0"
        ],
        [
          "1",
          "1"
        ]
      ]
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 150,
  "tooltip": "",
  "helpUrl": ""
},
{
  "type": "led_block_b",
  "message0": "LED %1 0~100 %2",
  "args0": [
    {
      "type": "field_dropdown",
      "name": "NAME1",
      "options": [
        [
          "BackGreen",
          "BG"
        ],
        [
          "BackRed",
          "BR"
        ]
      ]
    },
    {
      "type": "field_input",
      "name": "Value",
      "text": "0"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 150,
  "tooltip": "",
  "helpUrl": ""
}
  
]);  // END JSON EXTRACT (Do not delete this comment.)

