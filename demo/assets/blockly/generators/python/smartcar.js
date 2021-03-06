






Blockly.Python['robot_motion'] = function(block) {
  var text_speed = block.getFieldValue('speed');
  var text_rad = block.getFieldValue('rad');
  var value_speed_rad = Blockly.Python.valueToCode(block, 'speed_rad', Blockly.Python.ORDER_ATOMIC);
  // TODO: Assemble Python into code variable.
  var code = 'car.set_speed'+'('+text_speed+','+text_rad+')'+'\n'
  return code;
};



Blockly.Python['time'] = function(block) {
  var text_time = block.getFieldValue('time');
  var value_time = Blockly.Python.valueToCode(block, 'Time', Blockly.Python.ORDER_ATOMIC);
  // TODO: Assemble Python into code variable.
  var code = '...\n';
  var code='time.sleep'+'('+text_time+')'+'\n'
  return code;
};


Blockly.Python['led'] = function(block) {
	
  var dropdown_fb = block.getFieldValue('FB');
  var dropdown_gr = block.getFieldValue('GR');
  var dropdown_oc = block.getFieldValue('OC');
  var value_led_state = Blockly.Python.valueToCode(block, 'led_state', Blockly.Python.ORDER_ATOMIC);
  // TODO: Assemble Python into code variable.
  
  
  var code = '...\n';
  return code;
};


Blockly.Python['while_do'] = function(block) {
  var statements_while = Blockly.Python.statementToCode(block, 'while');
  var statements_do = Blockly.Python.statementToCode(block, 'do');
  // TODO: Assemble Python into code variable.
  var argument0 = Blockly.Python.valueToCode(block, 'BOOL') || 'False';
  var branch = Blockly.Python.statementToCode(block, 'DO');
  branch = Blockly.Python.addLoopTrap(branch, block) || Blockly.Python.PASS;
  return 'while ' + argument0 + ':\n' + branch;
  
 // var code = '...\n';
 // return code;
};