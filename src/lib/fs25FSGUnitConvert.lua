
FS25FSGUnits = {}

local FS25FSGUnits_mt = Class(FS25FSGUnits)

FS25FSGUnits.unit_types = {}
FS25FSGUnits.unit_types.SOLID  = 1
FS25FSGUnits.unit_types.LIQUID = 2
FS25FSGUnits.unit_types.NONE   = 3

FS25FSGUnits.unitsToIndex = {
	LITER   = 1,
	BUSHEL  = 2,
	C_METER = 3,
	C_FOOT  = 4,
	C_YARD  = 5,
	KG      = 6,
	OZ      = 7,
	LBS     = 8,
	CWT     = 9,
	MT      = 10,
	T       = 11,
	F_OZ    = 12,
	GAL     = 13,
}

FS25FSGUnits.units = {
	[FS25FSGUnits.unitsToIndex.LITER]   = { precision = 0, isWeight = false, text = "unit_literShort",     factor = 1 },
	[FS25FSGUnits.unitsToIndex.BUSHEL]  = { precision = 2, isWeight = false, text = "unit_bushelsShort",   factor = 0.028378 },
	[FS25FSGUnits.unitsToIndex.C_METER] = { precision = 3, isWeight = false, text = "unit_cubicShort",    factor = 0.001 },
	[FS25FSGUnits.unitsToIndex.C_FOOT]  = { precision = 2, isWeight = false, text = "unit_fsgUnitConvert_cubicFoot",   factor = 0.035315 },
	[FS25FSGUnits.unitsToIndex.C_YARD]  = { precision = 2, isWeight = false, text = "unit_fsgUnitConvert_cubicYard",   factor = 0.001308},
	[FS25FSGUnits.unitsToIndex.KG]      = { precision = 0, isWeight = true,  text = "unit_kg",    factor = 1 },
	[FS25FSGUnits.unitsToIndex.OZ]      = { precision = 0, isWeight = true,  text = "unit_fsgUnitConvert_ounce",    factor = 35.27396 },
	[FS25FSGUnits.unitsToIndex.LBS]     = { precision = 0, isWeight = true,  text = "unit_fsgUnitConvert_poundWeight",   factor = 2.204623 },
	[FS25FSGUnits.unitsToIndex.CWT]     = { precision = 2, isWeight = true,  text = "unit_fsgUnitConvert_hundredWeight",   factor = 0.022046 },
	[FS25FSGUnits.unitsToIndex.MT]      = { precision = 3, isWeight = true,  text = "unit_tonsShort",    factor = 0.001 },
	[FS25FSGUnits.unitsToIndex.T]       = { precision = 3, isWeight = true,  text = "unit_fsgUnitConvert_imperialTon",     factor = 0.0011023 },
	[FS25FSGUnits.unitsToIndex.F_OZ]    = { precision = 0, isWeight = false, text = "unit_fsgUnitConvert_fluidOunce", factor = 33.814023 },
	[FS25FSGUnits.unitsToIndex.GAL]     = { precision = 2, isWeight = false, text = "unit_fsgUnitConvert_fluidGallon",   factor = 0.264172},
}

FS25FSGUnits.unit_select = {
	[FS25FSGUnits.unit_types.SOLID] = {
		FS25FSGUnits.unitsToIndex.LITER,
		FS25FSGUnits.unitsToIndex.BUSHEL,
		FS25FSGUnits.unitsToIndex.C_METER,
		FS25FSGUnits.unitsToIndex.C_FOOT,
		FS25FSGUnits.unitsToIndex.C_YARD,
		FS25FSGUnits.unitsToIndex.KG,
		FS25FSGUnits.unitsToIndex.OZ,
		FS25FSGUnits.unitsToIndex.LBS,
		FS25FSGUnits.unitsToIndex.CWT,
		FS25FSGUnits.unitsToIndex.MT,
		FS25FSGUnits.unitsToIndex.T,
	},
	[FS25FSGUnits.unit_types.LIQUID] = {
		FS25FSGUnits.unitsToIndex.LITER,
		FS25FSGUnits.unitsToIndex.F_OZ,
		FS25FSGUnits.unitsToIndex.GAL,
		FS25FSGUnits.unitsToIndex.KG,
		FS25FSGUnits.unitsToIndex.OZ,
		FS25FSGUnits.unitsToIndex.LBS,
		FS25FSGUnits.unitsToIndex.CWT,
		FS25FSGUnits.unitsToIndex.MT,
		FS25FSGUnits.unitsToIndex.T,
	}
}

function FS25FSGUnits:new()
	local self = setmetatable({}, FS25FSGUnits_mt)


	-- cSpell: disable
	self.unit_type_liquid = {
		[FillType.SILAGE_ADDITIVE]  = true,
		[FillType.LIQUIDFERTILIZER] = true,
		[FillType.HERBICIDE]        = true,
		[FillType.MILK]             = true,
		[FillType.WATER]            = true,
		[FillType.DEF]              = true,
		[FillType.SUNFLOWER_OIL]    = true,
		[FillType.DIESEL]           = true,
		[FillType.CANOLA_OIL]       = true,
		[FillType.OLIVE_OIL]        = true,
		[FillType.RICE_OIL]         = true,
		[FillType.GRAPEJUICE]       = true,
		[FillType.LIQUIDMANURE]     = true,
		[FillType.DIGESTATE]        = true,
		[FillType.GOATMILK]         = true,
		[FillType.BUFFALOMILK]      = true,
	}

	self.unit_type_bales = {
		[FillType.ROUNDBALE]           = true,
		[FillType.ROUNDBALE_GRASS]     = true,
		[FillType.ROUNDBALE_DRYGRASS]  = true,
		[FillType.ROUNDBALE_COTTON]    = true,
		[FillType.ROUNDBALE_WOOD]      = true,
		[FillType.SQUAREBALE]          = true,
		[FillType.SQUAREBALE_COTTON]   = true,
		[FillType.SQUAREBALE_WOOD]     = true,
		[FillType.SQUAREBALE_DRYGRASS] = true,
		[FillType.SQUAREBALE_GRASS]    = true,
	}
	-- cSpell: enable

	return self
end

function FS25FSGUnits.getSettingsTexts(unitType)
	-- Args:
	--  - unitType : FS25FSGUnits.unit_types.SOLID or FS25FSGUnits.unit_types.LIQUID
	local settingsTable = {}

	if FS25FSGUnits.unit_select[unitType] == nil then
		return settingsTable
	end

	for _, typeIdx in ipairs(FS25FSGUnits.unit_select[unitType]) do
		local thisUnitMeasure = g_i18n:getText('unit_fsgUnitConvert_Volume')

		if FS25FSGUnits.units[typeIdx].isWeight then
			thisUnitMeasure = g_i18n:getText('unit_fsgUnitConvert_Weight')
		end

		local thisUnit = thisUnitMeasure .. " | " .. g_i18n:getText(FS25FSGUnits.units[typeIdx].text)
		table.insert(settingsTable, thisUnit)
	end

	return settingsTable
end

function FS25FSGUnits:getUnitType(fillTypeIdx)
	-- Args:
	--  - fillTypeIdx : fillType index.  Same as to g_fillTypeManager:getFillTypeByIndex()
	if self.unit_type_bales[fillTypeIdx] ~= nil then
		return FS25FSGUnits.unit_types.NONE
	end

	if self.unit_type_liquid[fillTypeIdx] ~= nil then
		return FS25FSGUnits.unit_types.LIQUID
	end

	if g_fillTypeManager:getIsFillTypeInCategory(fillTypeIdx, 'ANIMAL') or g_fillTypeManager:getIsFillTypeInCategory(fillTypeIdx, 'HORSE') then
		return FS25FSGUnits.unit_types.NONE
	end

	return FS25FSGUnits.unit_types.SOLID
end

function FS25FSGUnits:scaleFillTypeLevel(fillTypeIdx, fillLevel, unitIdxSolid, unitIdxLiquid, showUnit, showFormat)
	-- Args :
	--  - fillTypeIdx :  fillType index.  Same as to g_fillTypeManager:getFillTypeByIndex()
	--  - fillLevel : Numeric fill level
	--  - unitIdxSolid : Unit to use for solids, from FS25FSGUnits.unit_select[<unit type>]
	--  - unitIdxLiquid : Unit to use for liquids, from FS25FSGUnits.unit_select[<unit type>]
	--  - showUnit : append unit to returned value, default true
	--  - showFormat: format the number (l10n)
	local numberFormat = Utils.getNoNil(showFormat, true)
	local showTheUnit  = Utils.getNoNil(showUnit, true)
	local fillType     = g_fillTypeManager:getFillTypeByIndex(fillTypeIdx)
	local massPerLiter = Utils.getNoNil(fillType.massPerLiter, 1)
	local unitType     = self:getUnitType(fillTypeIdx)
	local realUnitIdx  = 1

	if unitType == FS25FSGUnits.unit_types.NONE then
		return fillLevel
	end

	if unitType == FS25FSGUnits.unit_types.LIQUID then
		realUnitIdx = FS25FSGUnits.unit_select[unitType][unitIdxLiquid]
	end
	if unitType == FS25FSGUnits.unit_types.SOLID then
		realUnitIdx = FS25FSGUnits.unit_select[unitType][unitIdxSolid]
	end

	local unitData        = FS25FSGUnits.units[realUnitIdx]
	local returnFillLevel = fillLevel

	if unitData.isWeight then
		returnFillLevel = fillLevel * massPerLiter * 1000
	end

	local convertedFillLevel = MathUtil.round(returnFillLevel * unitData.factor, unitData.precision)

	if numberFormat then
		if showTheUnit then
			return g_i18n:formatVolume(convertedFillLevel, unitData.precision, g_i18n:getText(unitData.text))
		else
			return g_i18n:formatVolume(convertedFillLevel, unitData.precision, '')
		end
	end

	if showTheUnit then
		return tostring(convertedFillLevel) .. " " .. g_i18n:getText(unitData.text)
	else
		return tostring(convertedFillLevel)
	end
end

