Blockly.Blocks['motor_total'] = {
    init: function() {
      this.appendDummyInput()
          .appendField("Move Motor")
          .appendField(new Blockly.FieldSlider(-100, 100, 1), "motor_total");
      this.setPreviousStatement(true, null);
      this.setNextStatement(true, null);
      this.setColour(230);
      this.setTooltip('');
      this.setHelpUrl('');
    }
  };
  