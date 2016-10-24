/datum/power/changeling/resonant_shriek
	name = "Resonant Shriek"
	desc = "Our lungs and vocal chords shift, allowing us to briefly emit a noise that deafens and confuses the weak-minded biologicals and synthetics."
	helptext = "Lights are blown, organics are disoriented, and synthetics act as if they were flashed."
	enhancedtext = "Range is doubled."
	genomecost = 2
	verbpath = /mob/living/proc/changeling_resonant_shriek

/datum/power/changeling/dissonant_shriek
	name = "Dissonant Shriek"
	desc = "We shift our vocal cords to release a high-frequency sound that overloads nearby electronics."
	helptext = "Creates a moderate sized EMP."
	enhancedtext = "Range is doubled."
	genomecost = 2
	verbpath = /mob/living/proc/changeling_dissonant_shriek

//A flashy ability, good for crowd control and sewing chaos.
/mob/living/proc/changeling_resonant_shriek()
	set category = "Changeling"
	set name = "Resonant Shriek (20)"
	set desc = "Emits a high-frequency sound that confuses and deafens humans, blows out nearby lights and overloads cyborg sensors."

	var/datum/changeling/changeling = changeling_power(20,0,100,CONSCIOUS)
	if(!changeling)	return 0

	if(is_muzzled())
		src << "<span class='danger'>Mmmf mrrfff!</span>"
		return 0

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.silent)
			src << "<span class='danger'>You can't speak!</span>"
			return 0

	changeling.chem_charges -= 20
	var/range = 4
	if(src.mind.changeling.recursive_enhancement)
		range = range * 2
		src << "<span class='notice'>We are extra loud.</span>"
		src.mind.changeling.recursive_enhancement = 0

	for(var/mob/living/M in range(range, src))
		if(iscarbon(M))
			var/mob/living/carbon/C
			if(!C.mind || !C.mind.changeling)
				if(C.get_ear_protection() >= 2)
					continue
				C << "<span class='danger'>You hear an extremely loud screeching sound!  It \
				[pick("confuses","confounds","perturbs","befuddles","dazes","unsettles","disorients")] you.</span>"
				C.adjustEarDamage(0,30)
				C.confused += 20
				C << sound('sound/effects/screech.ogg')
			else
				if(M != src)
					M << "<span class='notice'>You hear a familiar screech from nearby.  It has no effect on you.</span>"
				M << sound('sound/effects/screech.ogg')

		if(issilicon(M))
			M << sound('sound/weapons/flash.ogg')
			M << "<span class='notice'>Auditory input overloaded.  Reinitializing...</span>"
			M.Weaken(rand(5,10))

	for(var/obj/machinery/light/L in range(range, src))
		L.on = 1
		L.broken()

	return 1

//EMP version
/mob/living/proc/changeling_dissonant_shriek()
	set category = "Changeling"
	set name = "Dissonant Shriek (20)"
	set desc = "We shift our vocal cords to release a high-frequency sound that overloads nearby electronics."

	var/datum/changeling/changeling = changeling_power(20,0,100,CONSCIOUS)
	if(!changeling)	return 0

	if(is_muzzled())
		src << "<span class='danger'>Mmmf mrrfff!</span>"
		return 0

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.silent)
			src << "<span class='danger'>You can't speak!</span>"
			return 0

	changeling.chem_charges -= 20

	var/range_heavy = 2
	var/range_light = 5
	if(src.mind.changeling.recursive_enhancement)
		range_heavy = range_heavy * 2
		range_light = range_light * 2
		src << "<span class='notice'>We are extra loud.</span>"
		src.mind.changeling.recursive_enhancement = 0

	for(var/obj/machinery/light/L in range(5, src))
		L.on = 1
		L.broken()
	empulse(get_turf(src), range_heavy, range_light, 1)
	return 1