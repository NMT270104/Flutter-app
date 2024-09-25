'use strict';

const startKulbot = 'event_program_starts';
const start_state_name = "DO";

Blockly.defineBlocksWithJsonArray([
  {
    "type": startKulbot,
    "message0": "when Kulbot begin",
    "args1": [
      {
        "type": "input_statement",
        "name": start_state_name, // Đảm bảo sử dụng tên đúng
      }
    ],
    "colour": 120,
    "nextStatement": true
  }
]);


javascript.javascriptGenerator.forBlock[startKulbot] = function(block) {
  try {
    console.log(block); // Kiểm tra nội dung block
    const doInput = block.getInput(start_state_name); // Lấy input DO
    console.log(doInput); // Kiểm tra thông tin input DO

    if (!doInput) {
      throw new Error(`Input "${start_state_name}" không tồn tại trong block.`);
    }

    var importLib = "#include <Arduino.h> \n#include <KULBOT.h>";
    var globalVariable = "KULBOT Rob;";
    var setUp = "void setup() { \n Rob.KULBOT_INIT(); \n}";

    // Lấy mã từ input DO
    var statement_do = javascript.javascriptGenerator.statementToCode(block, start_state_name) || ''; 

    var loop = `void loop() { \n ${statement_do} \n}`;

    var code = importLib + "\n" + globalVariable + "\n" + setUp + "\n" + loop + "\n";
    return code;

  } catch (e) {
    console.error("Error generating code:", e);
    return 'Error generating code';
  }
};

const workspace = Blockly.inject('blocklyDiv', { toolbox: document.getElementById('toolbox') });
const block = workspace.newBlock('event_program_starts');
block.initSvg();
block.render(); // Vẽ khối

console.log("Block:", block);
console.log("Block Inputs:", block.inputList); // In ra danh sách các input của block

// Chuyển block thành mã
const code = Blockly.JavaScript.blockToCode(block);
console.log(code);

