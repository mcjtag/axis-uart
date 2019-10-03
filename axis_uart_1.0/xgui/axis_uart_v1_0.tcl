# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {Settings}]
  set_property tooltip {Settings} ${Page_0}
  ipgui::add_param $IPINST -name "BAUD_PRESCALER" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PARITY" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "BYTE_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "STOP_BITS" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "FIFO_DEPTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "FLOW_CONTROL" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "DYNAMIC_CONFIG" -parent ${Page_0} -widget comboBox


}

proc update_PARAM_VALUE.BAUD_PRESCALER { PARAM_VALUE.BAUD_PRESCALER } {
	# Procedure called to update BAUD_PRESCALER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BAUD_PRESCALER { PARAM_VALUE.BAUD_PRESCALER } {
	# Procedure called to validate BAUD_PRESCALER
	return true
}

proc update_PARAM_VALUE.BYTE_SIZE { PARAM_VALUE.BYTE_SIZE } {
	# Procedure called to update BYTE_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BYTE_SIZE { PARAM_VALUE.BYTE_SIZE } {
	# Procedure called to validate BYTE_SIZE
	return true
}

proc update_PARAM_VALUE.DYNAMIC_CONFIG { PARAM_VALUE.DYNAMIC_CONFIG } {
	# Procedure called to update DYNAMIC_CONFIG when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DYNAMIC_CONFIG { PARAM_VALUE.DYNAMIC_CONFIG } {
	# Procedure called to validate DYNAMIC_CONFIG
	return true
}

proc update_PARAM_VALUE.FIFO_DEPTH { PARAM_VALUE.FIFO_DEPTH } {
	# Procedure called to update FIFO_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FIFO_DEPTH { PARAM_VALUE.FIFO_DEPTH } {
	# Procedure called to validate FIFO_DEPTH
	return true
}

proc update_PARAM_VALUE.FLOW_CONTROL { PARAM_VALUE.FLOW_CONTROL } {
	# Procedure called to update FLOW_CONTROL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FLOW_CONTROL { PARAM_VALUE.FLOW_CONTROL } {
	# Procedure called to validate FLOW_CONTROL
	return true
}

proc update_PARAM_VALUE.PARITY { PARAM_VALUE.PARITY } {
	# Procedure called to update PARITY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PARITY { PARAM_VALUE.PARITY } {
	# Procedure called to validate PARITY
	return true
}

proc update_PARAM_VALUE.STOP_BITS { PARAM_VALUE.STOP_BITS } {
	# Procedure called to update STOP_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STOP_BITS { PARAM_VALUE.STOP_BITS } {
	# Procedure called to validate STOP_BITS
	return true
}


proc update_MODELPARAM_VALUE.BAUD_PRESCALER { MODELPARAM_VALUE.BAUD_PRESCALER PARAM_VALUE.BAUD_PRESCALER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BAUD_PRESCALER}] ${MODELPARAM_VALUE.BAUD_PRESCALER}
}

proc update_MODELPARAM_VALUE.PARITY { MODELPARAM_VALUE.PARITY PARAM_VALUE.PARITY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PARITY}] ${MODELPARAM_VALUE.PARITY}
}

proc update_MODELPARAM_VALUE.BYTE_SIZE { MODELPARAM_VALUE.BYTE_SIZE PARAM_VALUE.BYTE_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BYTE_SIZE}] ${MODELPARAM_VALUE.BYTE_SIZE}
}

proc update_MODELPARAM_VALUE.STOP_BITS { MODELPARAM_VALUE.STOP_BITS PARAM_VALUE.STOP_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STOP_BITS}] ${MODELPARAM_VALUE.STOP_BITS}
}

proc update_MODELPARAM_VALUE.FIFO_DEPTH { MODELPARAM_VALUE.FIFO_DEPTH PARAM_VALUE.FIFO_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIFO_DEPTH}] ${MODELPARAM_VALUE.FIFO_DEPTH}
}

proc update_MODELPARAM_VALUE.FLOW_CONTROL { MODELPARAM_VALUE.FLOW_CONTROL PARAM_VALUE.FLOW_CONTROL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FLOW_CONTROL}] ${MODELPARAM_VALUE.FLOW_CONTROL}
}

proc update_MODELPARAM_VALUE.DYNAMIC_CONFIG { MODELPARAM_VALUE.DYNAMIC_CONFIG PARAM_VALUE.DYNAMIC_CONFIG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DYNAMIC_CONFIG}] ${MODELPARAM_VALUE.DYNAMIC_CONFIG}
}

