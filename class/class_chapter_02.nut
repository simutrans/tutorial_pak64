/*
 *  class chapter_02
 *
 *
 *  Can NOT be used in network game !
 */

// Step 3 =====================================================================================
ch2_cov_lim1 <- {a = (-1), b = 1}

// Step 5 =====================================================================================
ch2_cov_lim2 <- {a = 0, b = 4}

// Step 6 =====================================================================================
ch2_cov_lim3 <- {a = 3, b = 5}
	
class tutorial.chapter_02 extends basic_chapter
{
	chapter_name  = "Ruling the Roads"
	chapter_coord = coord(115,185)

	startcash     = 800000	   				// pl=0 startcash; 0=no reset
	comm_script = false
	stop_mark = false 

	gltool = null
	gl_wt = wt_road

	//Limites para las ciudades
	city1_lim = {a = coord(109,181), b = coord(128,193)}
	city2_lim = {a = coord(120,150), b = coord(138,159)} 
	cty1 = {c = coord(111,184), name = ""}

	// Step 1 =====================================================================================
	//Carretera para el deposito
	dep_lim1 = {a = null, b = null}
	dep_lim2 = {a = null, b = null}
	coorda = coord(115,186)
	c_dep = coord(115,185) // depot
	coordb = coord(116,185)
	cursor_a = false
	cursor_b = false

	// Step 3 =====================================================================================
	//Parasdas de autobus
	c_lock = [coord(99,28), coord(98,32), coord(99,32), coord(97,27), coord(97,26)]
	sch_cov_correct = false
	sch_list1 =	[coord(111,183), coord(116,183),  coord(120,183), coord(126,187), coord(121,189), coord(118,191), coord(113,190)]

	// Step 4 =====================================================================================
	//Primer autobus
	line1_name = "Test 1"
	veh1_obj = "BuessingLinie"
	veh1_load = 100
	veh1_wait = 10571
	dep_cnr1 = null //auto started

	// Step 5 =====================================================================================
	// Primer puente
	brdg_lim = {a = coord(119,193), b = coord(128,201)}
	del_lim1 = {a = coord(119,193), b = coord(128,193)}
	brdg1 = coord(126,193)
	brdg2 = coord(126,195)

	c_brdg1 = {a = coord3d(126,193,-1), b = coord3d(126,196,0)}
	c_brdg_limi1 = {a = coord(126,192), b = coord(126,196)}

	// Step 6 =====================================================================================
	// Conectando el muelle
	dock_lim = {a = coord(128,181), b = coord(135,193)}
	del_lim2 = {a = coord(128,181), b = coord(128,193)}

	sch_list2 = [coord(132,189), coord(126,187), coord(121,189), coord(126,198), coord(120,196)]
	line2_name = "Test 2"
	dep_cnr2 = null //auto started
	cov_nr = 0

	// Step 7 =====================================================================================
	// Conectando las ciudades
	c_label1 = {a = coord(130,160), b = coord(130,185)}

	cty2 = {c = coord(129,154), name = ""}
	c_way_limi1 = {a = coord(127,159), b = coord(133,186)}
	c_way1 = {a = coord3d(130,160,0), b = coord3d(130,185,0)}
	c_st0 = coord(126,187)

	sch_list3 = [coord(126,187), coord(121,155), coord(127,155), coord(132,155), coord(135,153)]
	line3_name = "Test 3"
	dep_cnr3 = null //auto started
	

	// Step 8 =====================================================================================
	pub_st1 = coord(120,196)
	pub_st2 = coord(120,196)
	price = 1200

	//Script
	//----------------------------------------------------------------------------------
	sc_way_name = "asphalt_road"
	sc_bridge_name = "tb_classic_road"
	sc_station_name = "BusStop"
	sc_dep_name = "CarDepot"

	function start_chapter()  //Inicia solo una vez por capitulo
	{
		rules.clear()
		set_all_rules(0)

		cty1.name = get_city_name(cty1.c)
		cty2.name = get_city_name(cty2.c)

		dep_lim1 = {a = c_dep, b = coorda}
		dep_lim2 = {a = c_dep, b = coordb}

		dep_cnr1 = get_dep_cov_nr(ch2_cov_lim1.a,ch2_cov_lim1.b)
		dep_cnr2 = get_dep_cov_nr(ch2_cov_lim2.a,ch2_cov_lim2.b)
		dep_cnr3 = get_dep_cov_nr(ch2_cov_lim3.a,ch2_cov_lim3.b)

		local pl = 0
		//Schedule list form current convoy
		if(this.step == 4){
            local c_dep = this.my_tile(c_dep)
			local c_list = sch_list1
			start_sch_tmpsw(pl,c_dep, c_list)
		}
		else if(this.step == 6){
            local c_dep = this.my_tile(c_dep)
			local c_list = sch_list2
			start_sch_tmpsw(pl,c_dep, c_list)
		}
		else if(this.step == 7){
            local c_dep = this.my_tile(c_dep)
			local c_list = sch_list3
			start_sch_tmpsw(pl,c_dep, c_list)
		}
	}

	function set_goal_text(text){
		switch (this.step) {
			case 1:
				text.t1 = c_dep.href("("+c_dep.tostring()+")") 
				text.t2 = coorda.href("("+coorda.tostring()+")")
				text.t3 = coordb.href("("+coordb.tostring()+")") 
				break
			case 2:
				text.pos = c_dep.href("("+c_dep.tostring()+")")
				break
			case 3:
				local list_tx = ""
				local c_list = sch_list1
				local siz = c_list.len()
				for (local j=0;j<siz;j++){
					local c = coord(c_list[j].x, c_list[j].y)
					local tile = my_tile(c)
					local st_halt = tile.get_halt()
					local build = tile.find_object(mo_building)
					if (build){
						local link =  c.href(st_halt.get_name()+" ("+c.tostring()+")")
						list_tx += format("<em>%s %d:</em> %s<br>", translate("Stop"), j+1, link)
					}
					else{
						local link = c.href(" ("+c.tostring()+")")
						local stop_tx = translate("Build Stop here:")
						list_tx += format("<st>%s %d:</st></em> %s %s<br>", translate("Stop"), j+1, stop_tx, link)
					}                                             
				}
				text.list = list_tx
				break
			case 4:
				local list_tx = ""
				local c_list = sch_list1
				local siz = c_list.len()
				for (local j=0;j<siz;j++){
					local c = coord(c_list[j].x, c_list[j].y)
					local tile = my_tile(c)
					local st_halt = tile.get_halt()
					if(sch_cov_correct){
						list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
						continue
					}
					if(tmpsw[j]==0){
						list_tx += format("<st>%s %d:</st> %s<br>", translate("Stop"), j+1, c.href(st_halt.get_name()+" ("+c.tostring()+")"))
					}
					else{						
						list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
					}
				}
				local c = coord(c_list[0].x, c_list[0].y)
				local tile = my_tile(c)
				text.stnam = "1) "+tile.get_halt().get_name()+" ("+c.tostring()+")"
				
				text.list = list_tx
				text.nr = siz
				break
			case 5:
				text.bpos1 = brdg1.href("("+brdg1.tostring()+")")
				text.bpos2 = brdg2.href("("+brdg2.tostring()+")")
				break
			case 6:
				local stxt = array(10)
				local halt = my_tile(sch_list2[0]).get_halt()

				for (local j=0;j<sch_list2.len();j++){
					local c = coord(sch_list2[j].x, sch_list2[j].y)
					local st_halt = my_tile(c).get_halt()
					stxt[j] = c.href(st_halt.get_name()+" ("+c.tostring()+")")
				}
				if (current_cov==(ch2_cov_lim2.a+1)){
					text = ttextfile("chapter_02/06_1-2.txt")
					text.tx = ttext("<em>[1/2]</em>")
				}
				else if (current_cov<=(dep_cnr2)){
					text = ttextfile("chapter_02/06_2-2.txt")
					text.tx = ttext("<em>[2/2]</em>")
				}
				text.line = get_line_name(halt)
				text.st1 = stxt[0]
				text.st2 = stxt[1]
				text.st3 = stxt[2]
				text.st4 = stxt[3]
				text.st5 = stxt[4]
				text.st6 = stxt[5]
				text.st7 = stxt[6]
				text.st8 = stxt[7]
				text.cir = cov_nr
				text.cov = dep_cnr2

				break
			case 7:

				if (!cov_sw){
					local a = 3
					local b = 3
					text = ttextfile("chapter_02/07_"+a+"-"+b+".txt")
					text.tx = ttext("<em>["+a+"/"+b+"]</em>")
					local list_tx = ""
					local c_list = sch_list3
					local siz = c_list.len()
					for (local j=0;j<siz;j++){
						local c = coord(c_list[j].x, c_list[j].y)
						local tile = my_tile(c)
						local st_halt = tile.get_halt()
						if(sch_cov_correct){
							list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
							continue
						}
						if(tmpsw[j]==0){
							list_tx += format("<st>%s %d:</st> %s<br>", translate("Stop"), j+1, c.href(st_halt.get_name()+" ("+c.tostring()+")"))
						}
						else{						
							list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
						}
					}
					local c = coord(c_list[siz-1].x, c_list[siz-1].y)
					local tile = my_tile(c)
					text.stnam = ""+siz+") "+tile.get_halt().get_name()+" ("+c.tostring()+")"
					
					text.list = list_tx
					text.nr = siz
				}
				else if (pot0==0){
					local a = 1
					local b = 3
					text = ttextfile("chapter_02/07_"+a+"-"+b+".txt")
					text.tx = ttext("<em>["+a+"/"+b+"]</em>")

					local list_tx = ""
					local c_list = sch_list3
					local siz = c_list.len()
					for (local j=1;j<siz;j++){
						local c = coord(c_list[j].x, c_list[j].y)
						local tile = my_tile(c)
						local st_halt = tile.get_halt()
						local build = tile.find_object(mo_building)
						if (build){
							local link =  c.href(st_halt.get_name()+" ("+c.tostring()+")")
							list_tx += format("<em>%s %d:</em> %s<br>", translate("Stop"), j, link)
						}
						else{
							local link = c.href(" ("+c.tostring()+")")
							local stop_tx = translate("Build Stop here:")
							list_tx += format("<st>%s %d:</st></em> %s %s<br>", translate("Stop"), j, stop_tx, link)
						}                                             
					}
					text.list = list_tx
				}
				else if (pot2==0){
					local a = 2
					local b = 3
					text = ttextfile("chapter_02/07_"+a+"-"+b+".txt")
					text.tx = ttext("<em>["+a+"/"+b+"]</em>")

					if (r_way.r)
						text.cbor = "<em>"+translate("Ok")+"</em>"
					else
						text.cbor = coord(r_way.c.x, r_way.c.y).href("("+r_way.c.tostring()+")")
				}
				else if (pot3==0){
					local a = 3
					local b = 3
					text = ttextfile("chapter_02/07_"+a+"-"+b+".txt")
					text.tx = ttext("<em>["+a+"/"+b+"]</em>")

					local list_tx = ""
					local c_list = sch_list3
					local siz = c_list.len()
					for (local j=0;j<siz;j++){
						local c = coord(c_list[j].x, c_list[j].y)
						local tile = my_tile(c)
						local st_halt = tile.get_halt()
						if(sch_cov_correct){
							list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
							continue
						}
						if(tmpsw[j]==0){
							list_tx += format("<st>%s %d:</st> %s<br>", translate("Stop"), j+1, c.href(st_halt.get_name()+" ("+c.tostring()+")"))
						}
						else{						
							list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
						}
					}
					local c = coord(c_list[siz-1].x, c_list[siz-1].y)
					local tile = my_tile(c)
					text.stnam = ""+siz+") "+tile.get_halt().get_name()+" ("+c.tostring()+")"
					
					text.list = list_tx
					text.nr = siz
				}

				text.n1 = cty1.c.href(cty1.name.tostring())
				text.n2 = cty2.c.href(cty2.name.tostring())
				text.pt1 = c_label1.a.href("("+c_label1.a.tostring()+")")
				text.pt2 = c_label1.b.href("("+c_label1.b.tostring()+")")
				text.dep = c_dep.href("("+c_dep.tostring()+")")
				break

			case 8:
				local st_halt1 = my_tile(pub_st1).get_halt()
				local st_halt2 = my_tile(pub_st2).get_halt()
				text.st1 = pub_st1.href(st_halt1.get_name()+" ("+pub_st1.tostring()+")")
				//text.st2 = pub_st2.href(st_halt2.get_name()+" ("+pub_st2.tostring()+")")
				text.prce = money_to_string(price)
				break
		}
		text.load = veh1_load
		text.wait = get_wait_time_text(veh1_wait)
		text.pos = c_dep.href("("+c_dep.tostring()+")")
		text.bus1 = translate(veh1_obj)
		text.name = cty1.c.href(cty1.name.tostring())
		text.name2 = cty2.c.href(cty2.name.tostring())
		text.tool1 = tool_alias.inspe
		text.tool2 = tool_alias.road
		text.tool3 = tool_alias.spec

		return text
	}
	
	function is_chapter_completed(pl) {
		if (pl != 0) return 0		// only human player = 0
		
		local percentage=0

		save_glsw()
		save_pot()
		switch (this.step) {
			case 1:
				local next_mark = true
				local c_list = [my_tile(coordb), my_tile(coorda), my_tile(c_dep)]
				local m_buil = true
				try {
					 next_mark = delay_mark_tile_list(c_list, m_buil)
				}
				catch(ev) {
					return 0
				}

				cursor_a = cursor_control(my_tile(coorda))
				cursor_b = cursor_control(my_tile(coordb))

				//Para la carretera
				local tile = my_tile(c_dep)
				local way = tile.find_object(mo_way)
				local label = tile.find_object(mo_label)
				if (!way && !label){
					local t1 = command_x(tool_remover)
					local err1 = t1.work(player_x(pl), my_tile(c_dep), "")
					label_x.create(c_dep, player_x(pl), translate("Place the Road here!."))
					return 0
				}
				else if ((way)&&(way.get_owner().nr==pl)){
					if(next_mark ){
						tile.remove_object(player_x(pl), mo_label)
						this.next_step()
					}
				}

				return 0
				break;
			case 2:
				local next_mark = true
				try {
					 next_mark = delay_mark_tile(c_dep, c_dep,0)
				}
				catch(ev) {
					return 0
				}
				//Para el deposito
				local tile = my_tile(c_dep)
				local waydepo = tile.find_object(mo_way)
				if (!tile.find_object(mo_depot_road)){
					label_x.create(c_dep, player_x(pl), translate("Build a Depot here!."))
				}
				else if (next_mark){
					tile.remove_object(player_x(pl), mo_label)
					waydepo.unmark()
					this.next_step()
				}
				return 0
				break;
			case 3:
				if (pot0==0){
					//Marca tiles para evitar construccion de objetos
					local del = false
					local pl_nr = 1
					local text = "X"
                    lock_tile_list(c_lock, c_lock.len(), del, pl_nr, text)
					pot0=1
				}
				local siz = sch_list1.len()
				local c_list = sch_list1
				local name =  translate("Place Stop here!.")
				local load = good_alias.passa
				local all_stop = is_stop_building(siz, c_list, name, load)

				if (all_stop && pot0==1){
					this.next_step()
				}
				return 10+percentage
				break
			case 4:
				
				if (gcov_nr != 0 && gcov_nr != 1){
					return 0
				}
				if (pot0 == 0){
					local next_mark = true
					try {
						 next_mark = delay_mark_tile(c_dep, c_dep,0, stop_mark)
					}
					catch(ev) {
						return 0
					}
				}
				else if (pot0 == 1 && pot1 ==0){
					stop_mark = true
					local next_mark = true
					try {
						 next_mark = delay_mark_tile(c_dep, c_dep,0, stop_mark)
					}
					catch(ev) {
						return 0
					}
					pot1 = 1
				}

				if (pot1 == 1 ){	
					local c_dep = this.my_tile(c_dep)
		            local line_name = line1_name //"Test 1"
					set_convoy_schedule(pl, c_dep, gl_wt, line_name)

					local depot = depot_x(c_dep.x, c_dep.y, c_dep.z)
					local cov_list = depot.get_convoy_list()		//Lista de vehiculos en el deposito
					local convoy = convoy_x(gcov_id)
					if (cov_list.len()>=1){
						convoy = cov_list[0]
					}
					local all_result = checks_convoy_schedule(convoy, pl)

					sch_cov_correct = all_result.res == null ? true : false

				}
				if (current_cov == ch2_cov_lim1.b){
					local conv = my_tile(sch_list1[0]).find_object(mo_car)
					if (conv || comm_script) {						
						comm_script = false
						this.next_step()
						//Crear cuadro label
						local opt = 0
						label_bord(brdg_lim.a, brdg_lim.b, opt, false, "X")
						//Elimina cuadro label
						label_bord(del_lim1.a, del_lim1.b, opt, true, "X")
						//label_bord(c_lock.a, c_lock.b, opt, true, "X")
                        lock_tile_list(c_lock, c_lock.len(), true, 1)

					}
				}

				return 50
				break
			case 5:
				local t_label = my_tile(brdg1)
				local label = t_label.find_object(mo_label)

				local c_lim = {a = coord(c_brdg1.a.x, c_brdg1.a.y), b = coord(c_brdg1.b.x, c_brdg1.b.y)} 
				local next_mark = true
				if (pot0 == 0){
					if (!label)
						label_x.create(brdg1, player_x(pl), translate("Build a Bridge here!."))
					try {
						 next_mark = delay_mark_tile(c_lim.a, c_lim.a, 0, stop_mark)
					}
					catch(ev) {
						return 0
					}
				}
				else if (pot0 == 1 && pot1 ==0){
					stop_mark = true
					try {
						 next_mark = delay_mark_tile(c_lim.a, c_lim.a, 0, stop_mark)
					}
					catch(ev) {
						return 0
					}
					pot1 = 1
				}
				if (pot1==1) {
					//Comprueba la conexion de la via
					local coora = coord3d(c_brdg1.a.x, c_brdg1.a.y, c_brdg1.a.z)
					local coorb = coord3d(c_brdg1.b.x, c_brdg1.b.y, c_brdg1.b.z)
					local dir = 3
					local obj = false		
					local r_way = get_fullway(coora, coorb, dir, obj)
					if (r_way.r){
						t_label.remove_object(player_x(pl), mo_label)
						this.next_step()
						//Crear cuadro label
						local opt = 0
						label_bord(dock_lim.a, dock_lim.b, opt, false, "X")
						//Elimina cuadro label
						label_bord(del_lim2.a, del_lim2.b, opt, true, "X")	
					}
				}
				return 65
				break

			case 6:
				if (gcov_nr < 1 && gcov_nr>3)
					return 0

                local c_dep = this.my_tile(c_dep)
                local line_name = line2_name //"Test 2"
                set_convoy_schedule(pl,c_dep, gl_wt, line_name)

				local id_start = 1
				local id_end = 3
				cov_nr = get_convoy_number_exp(sch_list2[0], c_dep, id_start, id_end)

				local convoy = convoy_x(gcov_id)
				local all_result = checks_convoy_schedule(convoy, pl)
				if(!all_result.cov ){
					reset_glsw()
				}

				if (current_cov==ch2_cov_lim2.b){
					this.next_step()
					//Elimina cuadro label
					local opt = 0
					label_bord(city1_lim.a, city1_lim.b, opt, true, "X")
					label_bord(brdg_lim.a, brdg_lim.b, opt, true, "X")
					label_bord(dock_lim.a, dock_lim.b, opt, true, "X")
					//Creea un cuadro label
					label_bord(city2_lim.a, city2_lim.b, opt, false, "X")
				}

				return 70
				break

			case 7:
				if (gcov_nr != 4 && gcov_nr != 5)
					return 0

				if (comm_script)
					return 0
			
				if (pot0==0){

					local siz = sch_list3.len()
					local c_list = sch_list3
					local name =  translate("Place Stop here!.")
					local load = good_alias.passa
					local all_stop = is_stop_building(siz, c_list, name, load)

					if (all_stop) {
						pot0=1
						reset_glsw()
					}
				}

				else if (pot0==1 && pot1==0){
					//Elimina cuadro label
					local opt = 0
					label_bord(city2_lim.a, city2_lim.b, opt, true, "X")

					//Creea un cuadro label
					opt = 0
					label_bord(c_way_limi1.a, c_way_limi1.b, opt, false, "X")

					//Limpia las carreteras
					opt = 2
					label_bord(c_way_limi1.a, c_way_limi1.b, opt, true, "X", gl_wt)

					pot1=1
				}

				else if (pot1==1 && pot2==0){
						//Comprueba la conexion de la via
						local coora = coord3d(c_way1.a.x,c_way1.a.y,c_way1.a.z)
						local coorb = coord3d(c_way1.b.x,c_way1.b.y,c_way1.b.z)
						local dir = 3
						local obj = false		
						local r_way = get_fullway(coora, coorb, dir, obj)

						//Para marcar inicio y fin de la via
						local waya = tile_x(coora.x,coora.y,coora.z).find_object(mo_way)
						local wayb = tile_x(coorb.x,coorb.y,coorb.z).find_object(mo_way)
						if (waya) waya.mark()	
						if (wayb) wayb.mark()

						if (r_way.r){
							//Para desmarcar inicio y fin de la carretera
							waya.unmark()
							wayb.unmark()

							my_tile(c_label1.a).remove_object(player_x(1), mo_label)
							my_tile(c_label1.b).remove_object(player_x(1), mo_label)

							//Elimina cuadro label
							local opt = 0
							label_bord(c_way_limi1.a, c_way_limi1.b, opt, true, "X")

							//Creea un cuadro label
							local opt = 0
							label_bord(city1_lim.a, city1_lim.b, opt, false, "X")
							label_bord(city2_lim.a, city2_lim.b, opt, false, "X")

							pot2=1
						}
					}

					else if (pot2==1 && pot3 ==0){
						local c_dep = this.my_tile(c_dep)
				        local line_name = line3_name //"Test 3"
						set_convoy_schedule(pl, c_dep, gl_wt, line_name)

						local depot = depot_x(c_dep.x, c_dep.y, c_dep.z)
						local cov_list = depot.get_convoy_list()		//Lista de vehiculos en el deposito
						local convoy = convoy_x(gcov_id)
						if (cov_list.len()>=1){
							convoy = cov_list[0]
						}
						local all_result = checks_convoy_schedule(convoy, pl)
						sch_cov_correct = all_result.res == null ? true : false

						if (current_cov == ch2_cov_lim3.b){
							//Desmarca la via en la parada
							local way_mark = my_tile(c_st0).find_object(mo_way)
							way_mark.unmark()

							//Elimina cuadro label
							local opt = 0
							//label_bord(city1_lim.a, city1_lim.b, opt, true, "X")
							label_bord(city2_lim.a, city2_lim.b, opt, true, "X")
							this.next_step()
						}
					}
				return 95
				break

			case 8:
				if (pot0==0){
					local halt1 = my_tile(pub_st1).get_halt()
					local halt2 = my_tile(pub_st2).get_halt()
					if (pl != halt1.get_owner().nr)
						glsw[0]=1
					if (pl != halt2.get_owner().nr)
						glsw[1]=1

					if (glsw[0]==1 && glsw[1]==1){
						local opt = 0 
						label_bord(city1_lim.a, city1_lim.b, opt, true, "X")
						label_bord(city2_lim.a, city2_lim.b, opt, true, "X")
						this.next_step()
					}
				}
				
				return 98
				break
			case 9:
				this.step=1
				persistent.step=1
				persistent.status.step = 1

				return 100
				break
		}
		percentage=(this.step-1)+1
		return percentage
	}
	function is_work_allowed_here(pl, tool_id, pos) {		
		local t = tile_x(pos.x, pos.y, pos.z)
		local ribi = 0
		local slope = t.get_slope()
		local way = t.find_object(mo_way)
		local bridge = t.find_object(mo_bridge)
		local build = t.find_object(mo_building)
		local label = t.find_object(mo_label)
		local car = t.find_object(mo_car)
		if (way){
			if (tool_id!=tool_build_bridge)
				ribi = way.get_dirs()
			if (!t.has_way(gl_wt))
				ribi = 0
		}
		local st_c = coord(pos.x,pos.y)
		local result=null	// null is equivalent to 'allowed'
		result = translate("Action not allowed")+" ("+pos.tostring()+")."
		gltool = tool_id
		switch (this.step) {
			//Construye un tramo de carretera
			case 1:
				if (tool_id==tool_build_way){
					if ((pos.x>=dep_lim1.a.x)&&(pos.y>=dep_lim1.a.y)&&(pos.x<=dep_lim1.b.x)&&(pos.y<=dep_lim1.b.y)){
						if(!cursor_b)
							return null
					}
					if ((pos.x>=dep_lim2.a.x)&&(pos.y>=dep_lim2.a.y)&&(pos.x<=dep_lim2.b.x)&&(pos.y<=dep_lim2.b.y)){
						if(!cursor_a)
							return null
					}
					return translate("Connect the road here")+" ("+c_dep.tostring()+")."
				}
				break;
			//Construye un deposito de carreteras
			case 2:
				if ((pos.x==c_dep.x)&&(pos.y==c_dep.y)){
					if (my_tile(c_dep).find_object(mo_way)){
						if (tool_id==tool_build_depot) return null
					}
					else { 
						this.backward_step()
						return translate("You must first build a stretch of road")+" ("+pos.x+","+pos.y+")." 
					}			
				}
				else if (tool_id==tool_build_depot)
					return result=translate("You must build the depot in")+" ("+c_dep.tostring()+")."

				break;
			//Construye las paradas de autobus
			case 3:
				if (pos.x == c_dep.x && pos.y == c_dep.y )
					return format(translate("You must build the %d stops first."),7)
				if (pos.x>city1_lim.a.x && pos.y>city1_lim.a.y && pos.x<city1_lim.b.x && pos.y<city1_lim.b.y){
					//Permite construir paradas
					if (tool_id==tool_build_station){
						local nr = sch_list1.len()
						local c_st = sch_list1
						return build_stop(nr, c_st, t, way, slope, ribi, label, pos)
					}
					
					//Permite eliminar paradas
					if (tool_id==tool_remover){
						local nr = sch_list1.len()
						local c_st = sch_list1
						return delete_stop(nr, c_st, way, pos)
					}
				}
				else if (tool_id==tool_build_station)
					return result = format(translate("Stops should be built in [%s]"),cty1.name)+" ("+cty1.c.tostring()+")."

				break;
			//Enrutar el primer autobus
			case 4:
				if (tool_id==tool_build_station)
					return format(translate("Only %d stops are necessary."),sch_list1.len())
				
				//Enrutar vehiculo
				if ((pot4==0)){
					if ((pos.x == c_dep.x && pos.y == c_dep.y)){
						if(tool_id==4096){
							pot0 = 1
							return null
						}
					}
					if (tool_id==4108) {
						local c_list = sch_list1   //Lista de todas las paradas de autobus
						local c_dep = c_dep //Coordeadas del deposito 
						local siz = c_list.len() //Numero de paradas 
						result = translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+c_dep.tostring()+")."
						return is_stop_allowed(result, siz, c_list, pos)
					}
				}
				break;
			//Construye un puente
			case 5:
				if (tool_id==tool_build_bridge || tool_id==tool_build_way) {

					if ((pos.x>=c_brdg_limi1.a.x)&&(pos.y>=c_brdg_limi1.a.y)&&(pos.x<=c_brdg_limi1.b.x)&&(pos.y<=c_brdg_limi1.b.y)){
						pot0 = 1
						result=null
					}
					else
						return translate("You must build the bridge here")+" ("+brdg1.tostring()+")."			
				}
				break;
			//Segundo Autobus
			case 6:
				//Enrutar vehiculo
				if (pot0==0){
					if ((tool_id==4096)&&(pos.x == c_dep.x && pos.y == c_dep.y)){
						stop_mark = true
						return null
					}
					if (tool_id==4108) {
						stop_mark = true
						local c_list = sch_list2    //Lista de todas las paradas de autobus
						local c_dep = c_dep    //Coordeadas del deposito 
						local siz = c_list.len()     //Numero de paradas 
						result = translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+c_dep.tostring()+")."
						return is_stop_allowed(result, siz, c_list, pos)
					}
				}
				break;
			case 7:
				// Construye las paradas	
				if (pot0==0){
					if ((tool_id==tool_build_station)){
						if (pos.x>city2_lim.a.x && pos.y>city2_lim.a.y && pos.x<city2_lim.b.x && pos.y<city2_lim.b.y){

							local nr = sch_list3.len()
							local c_st = sch_list3
							return build_stop(nr, c_st, t, way, slope, ribi, label, pos)
						}

						else
							return format(translate("You must build a stop in [%s] first"), cty2.name)+" ("+cty2.c.tostring()+")."
					}
					//Permite eliminar paradas
					if (tool_id==tool_remover){
						for(local j=0;j<sch_list3.len();j++){
							if (sch_list3[j] != null){
								local stop = my_tile(sch_list3[j]).find_object(mo_building)
								if (pos.x==sch_list3[j].x&&pos.y==sch_list3[j].y&&stop){
									way.mark()
									return null
								}
							}
						}
						return translate("You can only delete the stops.")
					}
				}			
				//Para construir la carretera
				else if (pot1==1 && pot2==0){
					if ((pos.x>=c_way_limi1.a.x)&&(pos.y>=c_way_limi1.a.y)&&(pos.x<=c_way_limi1.b.x)&&(pos.y<=c_way_limi1.b.y)){
						if((pos.x==c_label1.a.x)&&(pos.y==c_label1.a.y)){
							if (tool_id==tool_remover || tool_id==tool_remove_way)
								return result
							else if (tool_id==tool_build_way)
								return null
						}
						else
							return all_control(result, gl_wt, way, ribi, tool_id, pos, r_way.c)
					}
				
				}
				//Para enrutar vehiculos
				else if (pot2==1 && pot3==0){
					if (tool_id==4108){
						//Paradas de la primera ciudad
						local c_list = sch_list3   //Lista de todas las paradas de autobus
						local c_dep = c_dep //Coordeadas del deposito 
						local siz = c_list.len() //Numero de paradas 
						result = translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+c_dep.tostring()+")."
						return is_stop_allowed(result, siz, c_list, pos)
					}			
				}
				break;

			//Paradas publicas
			case 8:
				if (tool_id==4128) {
					if (pos.x==pub_st1.x && pos.y==pub_st1.y){
						if (glsw[0]==0)
							return null
						else
							return format(translate("Select station No.%d"),2)+" ("+pub_st2.tostring()+")."
					}
					if (pos.x==pub_st2.x && pos.y==pub_st2.y){
						if (glsw[1]==0)
							return null
					}
					else {
						if (glsw[0]==0)
							return format(translate("Select station No.%d"),1)+" ("+pub_st1.tostring()+")."
						else if (glsw[1]==0)
							return format(translate("Select station No.%d"),2)+" ("+pub_st2.tostring()+")."
						}
				}
				break;
		}
		if (tool_id==4096){
			if (label && label.get_text()=="X")
				return translate("Indicates the limits for using construction tools")+" ("+pos.tostring()+")."	
	
			else if (label)	
				return translate("Text label")+" ("+pos.tostring()+")."

			result = null	// Always allow query tool
		}
		if (label && label.get_text()=="X")
			return translate("Indicates the limits for using construction tools")+" ("+pos.tostring()+")."	

		return result	
	}
	
	function is_schedule_allowed(pl, schedule) {
		local result=null	// null is equivalent to 'allowed'
		if ( (pl == 0) && (schedule.waytype != gl_wt) )
			result = translate("Only road schedules allowed")
		local nr = schedule.entries.len()
		switch (this.step) {
			case 4:
				local selc = 0
				local load = veh1_load
				local time = veh1_wait
				local c_list = sch_list1
				local siz = c_list.len()
				local line = true
				result = set_schedule_list(result, pl, schedule, nr, selc, load, time, c_list, siz, line)
				if(result == null){
					local line_name = line1_name //"Test 1"
					update_convoy_schedule(pl, gl_wt, line_name, schedule)
				}

				return result
			break
			case 6:
				local selc = 0
				local load = veh1_load
				local time = veh1_wait
				local c_list = sch_list2
				local siz = c_list.len()
				local line = true
				result = set_schedule_list(result, pl, schedule, nr, selc, load, time, c_list, siz, line)
				if(result == null){
					local line_name = line2_name //"Test 2"
					update_convoy_schedule(pl, gl_wt, line_name, schedule)
				}
				return result
			break
			case 7:
				local load = veh1_load
				local time = veh1_wait
				local c_list = sch_list3
				local siz = c_list.len()
				local selc = siz-1
				local line = true
				result = set_schedule_list(result, pl, schedule, nr, selc, load, time, c_list, siz, line)
				if(result == null){
					local line_name = line3_name //"Test 3"
					update_convoy_schedule(pl, gl_wt, line_name, schedule)
				}
				return result
			break
		}
		return translate("Action not allowed")
	}

	function is_convoy_allowed(pl, convoy, depot)
	{
		local result=null	// null is equivalent to 'allowed'
		switch (this.step) {
			case 4:
				if (current_cov>ch2_cov_lim1.a && current_cov<ch2_cov_lim1.b){
					/*if (comm_script){
						cov_save[current_cov]=convoy
						id_save[current_cov]=convoy.id
						gcov_nr++
						persistent.gcov_nr = gcov_nr
						return null
					}*/
					local cov = 1
					local veh = 1
					local good_list = [good_desc_x (good_alias.passa).get_catg_index()] 	 //Passengers
					local name = veh1_obj
					local st_tile = 1
					result = is_convoy_correct(depot,cov,veh,good_list,name, st_tile)

					if (result!=null){
						reset_tmpsw()
						return bus_result_message(result, translate(name), veh, cov)
					}
					local selc = 0
					local load = veh1_load
					local time = veh1_wait
					local c_list = sch_list1 
					local siz = c_list.len()
					result = set_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
					if(result == null)
						reset_tmpsw()
					return result
				}
			break
			case 6:
				if (current_cov>ch2_cov_lim2.a && current_cov<ch2_cov_lim2.b){
					/*if (comm_script){
						cov_save[current_cov]=convoy
						id_save[current_cov]=convoy.id
						gcov_nr++
						persistent.gcov_nr = gcov_nr
						return null
					}*/

					local cov_list = depot.get_convoy_list()
					local cov = cov_list.len()
					local veh = 1
					local good_list = [good_desc_x (good_alias.passa).get_catg_index()] 	 //Passengers
					local name = veh1_obj
					local st_tile = 1
					result = is_convoy_correct(depot,cov,veh,good_list,name, st_tile)
					if (result!=null){
						reset_tmpsw()
						return bus_result_message(result, translate(name), veh, cov)
					}

					local selc = 0
					local load = veh1_load
					local time = veh1_wait
					local c_list = sch_list2
					local siz = c_list.len()
					local line = true
					result = set_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz, line)
					if(result == null)
						reset_tmpsw()
					return result		
				}
			break
			case 7:
				if (current_cov>ch2_cov_lim3.a && current_cov<ch2_cov_lim3.b){
					/*if (comm_script){
						cov_save[current_cov]=convoy
						id_save[current_cov]=convoy.id
						gcov_nr++
						persistent.gcov_nr = gcov_nr
						return null
					}*/
					local cov = 1
					local veh = 1
					local good_list = [good_desc_x (good_alias.passa).get_catg_index()] 	 //Passengers
					local name = veh1_obj
					local st_tile = 1
					result = is_convoy_correct(depot,cov,veh,good_list,name, st_tile)
					if (result!=null){
						reset_tmpsw()
						return bus_result_message(result, translate(name), veh, cov)
					}

					local load = veh1_load
					local time = veh1_wait
					local c_list = sch_list3
					local siz = c_list.len()
					local selc = siz-1
					result = set_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
					if(result == null)
						reset_tmpsw()
					return result
				}
			break
			case 1:
			break
		}
		return result = translate("It is not allowed to start vehicles.")
	}

	function script_text()
	{
		if (!correct_cov)
			return 0
		local pl = 0
		switch (this.step) {
			case 1:
				delay_mark_tile(c_dep, c_dep,0, true)
				//Para la carretera
				local t1 = command_x(tool_remover)
				local err1 = t1.work(player_x(pl), my_tile(c_dep), "")
				local t2 = command_x(tool_build_way)			
				local err2 = t2.work(player_x(pl), my_tile(coorda), my_tile(c_dep), sc_way_name)
				return null
				break;
			case 2:
				delay_mark_tile(c_dep, c_dep,0, true)
				//Para el deposito
				local t = command_x(tool_build_depot)			
				local err = t.work(player_x(pl), my_tile(c_dep), sc_dep_name)	
				return null
				break;
			case 3:

				for(local j=0;j<sch_list1.len();j++){
					local t = my_tile(sch_list1[j])
					local way = t.find_object(mo_way)
					t.remove_object(player_x(1), mo_label)
					local tool = command_x(tool_build_station)			
					local err = tool.work(player_x(pl), t, sc_station_name)
					t.unmark()
					if (way.is_marked()){
						way.unmark()
					}
				}
				this.step_nr(4)	
				return null
				break
			case 4:
				//delay_mark_tile(c_dep, c_dep,0, true)
				comm_script = true
				if (pot0 == 0){
					pot0 = 1
				}

				if (current_cov>ch2_cov_lim1.a && current_cov<ch2_cov_lim1.b){
					local player = player_x(pl)
					local c_depot = my_tile(c_dep)

					comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito
					local good_nr = 0 //Passengers
					local name = veh1_obj
					local cov_nr = 0  //Max convoys nr in depot
					local c_list = sch_list1
					local sch_siz = c_list.len()

					if (!comm_set_convoy(cov_nr, c_depot, name))
						return 0
					local depot = depot_x(c_depot.x, c_depot.y, c_depot.z)
					local convoy = depot.get_convoy_list()
					local sched = schedule_x(gl_wt, [])
					local load = veh1_load
					local time = veh1_wait
					for(local j=0;j<sch_siz;j++){
						if (j==0)
							sched.entries.append(schedule_entry_x(my_tile(c_list[j]), load, time))
						else
							sched.entries.append(schedule_entry_x(my_tile(c_list[j]), 0, 0))
					}
					comm_start_convoy(player, gl_wt, sched, convoy, depot)

				}
				return null
				break
			case 5:
				if (pot0 == 0){
					pot0 = 1
				}
				if (pot0 == 1){
					local tile = my_tile(brdg1)
					tile.remove_object(player_x(pl), mo_label)
					local t = command_x(tool_build_bridge)
					t.set_flags(2)
					local err = t.work(player_x(pl), my_tile(brdg1), my_tile(brdg2), sc_bridge_name)
				}
	
				return null
				break

			case 6:
				local player = player_x(pl)
				local c_depot = my_tile(c_dep)

				comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito

				if (current_cov>ch2_cov_lim2.a && current_cov<ch2_cov_lim2.b){
					local good_nr = 0 //Passengers
					local name = veh1_obj
					local cov_nr = 0  //Max convoys nr in depot
					local c_list = sch_list2
					local sch_siz = c_list.len()
					local load = veh1_load
					local time = veh1_wait
					for (local j = current_cov; j>ch2_cov_lim2.a && j<ch2_cov_lim2.b && correct_cov; j++){
						if (!comm_set_convoy(cov_nr, c_depot, name))
							return 0
						local depot = depot_x(c_depot.x, c_depot.y, c_depot.z)
						local convoy = depot.get_convoy_list()
						if (convoy.len()==0) continue
						local sched = schedule_x(gl_wt, [])
						for(local i=0;i<sch_siz;i++){
							if (i==0)
								sched.entries.append(schedule_entry_x(my_tile(c_list[i]), load, time))
							else
								sched.entries.append(schedule_entry_x(my_tile(c_list[i]), 0, 0))
						}
						comm_start_convoy(player, gl_wt, sched, convoy, depot)
					}
				}
				return null
				break

			case 7:

				comm_script = true
				if (pot1==0){
					for(local j=0;j<sch_list3.len();j++){
						local t = my_tile(sch_list3[j])
						local way = t.find_object(mo_way)
						t.remove_object(player_x(1), mo_label)
						local tool = command_x(tool_build_station)			
						local err = tool.work(player_x(pl), t, sc_station_name)
						t.unmark()
						if (way.is_marked()){
							way.unmark()
						}
					}
				}
				if (pot2==0){
					local t = command_x(tool_build_way)			
					local err = t.work(player_x(pl), c_way1.a, c_way1.b, sc_way_name)
				}
				if (current_cov>ch2_cov_lim3.a && current_cov<ch2_cov_lim3.b){
					local player = player_x(pl)
					local c_depot = my_tile(c_dep)

					comm_destroy_convoy(pl, c_depot) // Limpia los vehiculos del deposito

					local good_nr = 0 //Passengers
					local name = veh1_obj
					local cov_nr = 0  //Max convoys nr in depot
					if (!comm_set_convoy(cov_nr, c_depot, name))
						return 0
					local depot = depot_x(c_depot.x, c_depot.y, c_depot.z)
					local convoy = depot.get_convoy_list()
					local sched = schedule_x(gl_wt, [])

					local c_list = sch_list3
					local sch_siz = c_list.len()
					local load = veh1_load
					local time = veh1_wait

					for(local j=0;j<sch_siz;j++){
						if (j==sch_siz-1)
							sched.entries.append(schedule_entry_x(my_tile(c_list[j]), load, time))
						else
							sched.entries.append(schedule_entry_x(my_tile(c_list[j]), 0, 0))
					}
					comm_start_convoy(player, gl_wt, sched, convoy, depot)
				}

				comm_script = false
				return null
				break

			case 8:
				if (pot0==0){
					local t = command_x(tool_make_stop_public)			
					t.work(player_x(pl), my_tile(pub_st1), "")
					//t.work(player_x(pl), my_tile(pub_st2), "")
				}
				return null
				break
		}
		return null
	}

	function set_all_rules(pl) {
		local forbid =	[	tool_remove_wayobj, tool_build_way, tool_build_bridge, tool_build_tunnel, tool_build_station,
                    		tool_remove_way, tool_build_depot, tool_build_roadsign, tool_build_wayobj
						]

		foreach(wt in all_waytypes){
			if (wt != wt_road){
				foreach (tool_id in forbid)
					rules.forbid_way_tool(pl, tool_id, wt )
			}
        }

		forbid =	[	4134,4135, tool_lower_land, tool_raise_land, tool_setslope, tool_build_transformer,
               			tool_restoreslope, tool_plant_tree, tool_set_marker, tool_add_city, 4137, tool_stop_mover, tool_buy_house
					]

		foreach (tool_id in forbid)
		    rules.forbid_tool(pl, tool_id )

		switch (this.step) {
			case 1:
				local forbid =	[	tool_remove_wayobj,tool_build_bridge,tool_build_tunnel,tool_build_station,
									tool_remove_way,tool_build_depot,tool_build_roadsign,tool_build_wayobj
								]
				foreach (tool_id in forbid)
					rules.forbid_way_tool(pl, tool_id, wt_road)

				local forbid = [tool_build_station,tool_remover,tool_make_stop_public]
				foreach (tool_id in forbid)
					rules.forbid_tool(pl, tool_id )	
					break

			case 2:
				local forbid =	[	tool_remove_wayobj,tool_build_way,tool_build_bridge,tool_build_tunnel,tool_build_station,
									tool_remove_way,tool_build_roadsign,tool_build_wayobj
								]
				foreach (tool_id in forbid)
					rules.forbid_way_tool(pl, tool_id, wt_road)

				local forbid = [tool_build_station,tool_remover,tool_make_stop_public]
				foreach (tool_id in forbid)
					rules.forbid_tool(pl, tool_id )				
				break

			case 3:
				local forbid=	[	tool_remove_wayobj,tool_build_way,tool_build_bridge,tool_build_tunnel,
									tool_remove_way,tool_build_depot,tool_build_roadsign,tool_build_wayobj
								]
				foreach (tool_id in forbid)
					rules.forbid_way_tool(pl, tool_id, wt_road)

				local forbid = [tool_make_stop_public]
				foreach (tool_id in forbid)
					rules.forbid_tool(pl, tool_id )	
				break

			case 4:
				local forbid =	[	tool_remove_wayobj,tool_build_way,tool_build_bridge,tool_build_tunnel,
									tool_remove_way,tool_build_depot,tool_build_roadsign,tool_build_wayobj
								]
				foreach (tool_id in forbid)
					rules.forbid_way_tool(pl, tool_id, wt_road)

				local forbid = [tool_build_station, tool_remover, tool_make_stop_public]
				foreach (tool_id in forbid)
					rules.forbid_tool(pl, tool_id )	
				break

			case 5:
				local forbid =	[	tool_remove_wayobj,tool_build_way,tool_build_tunnel,tool_build_station,
									tool_remove_way,tool_build_depot,tool_build_roadsign,tool_build_wayobj
								]
				foreach (tool_id in forbid)
					rules.forbid_way_tool(pl, tool_id, wt_road)

				local forbid = [tool_build_station,tool_remover,tool_make_stop_public]
				foreach (tool_id in forbid)
					rules.forbid_tool(pl, tool_id )	
				break

			case 6:
				local forbid =	[	tool_remove_wayobj,tool_build_way,tool_build_bridge,tool_build_tunnel,
									tool_remove_way,tool_build_depot,tool_build_roadsign,tool_build_wayobj
								]
				foreach (tool_id in forbid)
					rules.forbid_way_tool(pl, tool_id, wt_road)

				local forbid = [tool_build_station, tool_remover, tool_make_stop_public]
				foreach (tool_id in forbid)
					rules.forbid_tool(pl, tool_id )	
				break

			case 7:
				local forbid =	[	tool_build_bridge,tool_remove_wayobj,tool_build_tunnel,
									tool_build_depot,tool_build_roadsign,tool_build_wayobj
								]
					foreach (tool_id in forbid)
						rules.forbid_way_tool(pl, tool_id, wt_road)
				break

			case 8:
				local forbid =	[	tool_remove_wayobj,tool_build_way,tool_build_bridge,tool_build_tunnel,tool_build_station,
									tool_remove_way,tool_build_depot,tool_build_roadsign,tool_build_wayobj
								]
				foreach (tool_id in forbid)
					rules.forbid_way_tool(pl, tool_id, wt_road)

				local forbid = [tool_build_station,tool_remover]
				foreach (tool_id in forbid)
				rules.forbid_tool(pl, tool_id )	
				break	
		}
	}

	function sch_conv_list(pl, coord) {
		local c_dep = this.my_tile(coord)
		local depot = depot_x(c_dep.x, c_dep.y, c_dep.z)
		local cov_list = depot.get_convoy_list()		//Lista de vehiculos en el deposito
		local result = 0
		sch_list=false
		foreach(cov in cov_list) {
			try {
				cov.get_pos() 
			}
			catch(ev) {
				continue
			}
			local sch = null
			local line = cov.get_line()
			if (line)
				sch = line.get_schedule()

			else
				sch = cov.get_schedule()

			if (sch){
				if (is_schedule_allowed(pl, sch)==null)
					sch_list=true
			}
		}
		return result
	}
} 

// END OF FILE
