// Tạo Blockly workspace
const workspace = Blockly.inject('blocklyDiv', {
    toolbox: `
      <xml>
        <block type="controls_if"></block>
        <block type="logic_compare"></block>
        <block type="math_number">
          <field name="NUM">0</field>
        </block>
        <block type="text"></block>
      </xml>
    `,
    trashcan: true
  });
  
  // Hàm để tạo mã từ khối Blockly
  function generateCode() {
    const code = Blockly.JavaScript.workspaceToCode(workspace);
    document.getElementById('output').textContent = code;
  }
  