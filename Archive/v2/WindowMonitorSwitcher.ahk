sysget n, monitorcount
loop % n {
	sysget m_, monitorworkarea, % a_index
	fn := func("swapfs").bind(m_left, m_top, m_right - m_left, m_bottom - m_top)
	hotkey ^numpad%a_index%, % fn
}

swapfs(x, y, w, h) {
	winmove a,, x, y, w, h
}