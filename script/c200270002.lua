--Code Change
local s,id,o=GetID()
function c200270002.initial_effect(c)
	-- Select 1 face-up card on the field whose effect involves a Type(s) of monster and declare a Type. Until the End Phase, the Type(s) mentioned in the selected card's text becomes the declared Type.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ANNOUNCE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.filter(c)
	return c:IsFaceup() and s.involvesType(c)
end

function s.involvesType(c)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	if not mt then return false end
	local e=mt.initial_effect
	if not e then return false end
	return e(c):IsExists(Card.IsRace,1,nil,0xffff)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local race=Duel.AnnounceRace(tp,1,RACE_ALL)
	e:SetLabel(race)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local race=e:GetLabel()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(race)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
