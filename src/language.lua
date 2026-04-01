-- this is just an easy way for me to make a very basic programming language
-- language has no support for stuff like maths, or indexing, etc. its very simple.

local function set(arr)
	local set = {}
	for _, obj in ipairs(arr) do
		set[obj] = true
	end
	return set
end

local acceptableCharactersInIdentifiers = set {
	'-',
	'_',
	'.',
}

local linkNonAlphaNumerics = set { -- gpt made this list, for urls
	":", "/", "?", "#", "[", "]", "@", "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "=",
	"%", "~"
}

local function isNumeric(c, b)
	local b = b or string.byte(c)
	return b >= 48 and b <= 57
end

local function isAlphabetical(c, b)
	local b = b or string.byte(c)
	return (b >= 65 and b <= 90) or (b >= 97 and b <= 122)
end

local function isAlphanumerical(c, b)
	local b = b or string.byte(c)
	return isAlphabetical(nil, b) or isNumeric(nil, b)
end

local function isLinkCharacter(c)
	return linkNonAlphaNumerics[c]
end

local function isCharacter(c, b)
	local b = b or string.byte(c)
	return isAlphanumerical(nil, b) or isLinkCharacter(c) or acceptableCharactersInIdentifiers[c]
end

local function isString(c)
	return c == [["]] or c == [[']]
end

-- the programming language is below

local language = {}
language.__index = language

function language.New(parameters)
	local parameters = parameters or {}
	local keywords = parameters.keywords or {}
	
	for k, v in (keywords) do
		if (keywords[v]) then
			keywords[k] = keywords[v]
		end
	end

	return setmetatable({
		keywords = keywords or {},
		parameters = parameters or {},

		tokenizer = {
			char = '',
			index = 0,
			targetIndex = 0,

			token = {},
			tokens = {},

			column = 0,
			row = 0,
			rowTokens = {}
		},

		parser = {

		},
	}, language)
end

function language:Destroy()
	table.clear(self)
	setmetatable(self, nil)
end

-- lexer
function language:ResetTokenizer()
	self.tokenizer.char = ''
	self.tokenizer.index = 0
	self.tokenizer.targetIndex = 0

	table.clear(self.tokenizer.token)
	table.clear(self.tokenizer.tokens)

	self.tokenizer.column = 0
	self.tokenizer.row = 0
	table.clear(self.tokenizer.rowTokens)
end

function language:_nextCharacter()
	self.tokenizer.index += 1
	self.tokenizer.char = string.sub(
		self.tokenizer.targetString,
		self.tokenizer.index,
		self.tokenizer.index
	)
	self.tokenizer.column += 1

	return self.tokenizer.char
end

function language:_getCharacter()
	return self.tokenizer.char
end

function language:_isFinished()
	return self.tokenizer.index > self.tokenizer.targetIndex
end

function language:_isExactFinished()
	return self.tokenizer.index >= self.tokenizer.targetIndex
end

function language:_isNewline()
	return self:_getCharacter() == '\n'
end

function language:_isLineFinished()
	return self:_isFinished() or self:_isNewline()
end

function language:_singleForwardCheckMatch(text, index)
	local selection = string.sub(
		self.tokenizer.targetString,
		self.tokenizer.index,
		self.tokenizer.index + #text - 1
	)

	if (selection == text) then
		self.tokenizer.symbolFeed = index
		return true
	end
end

function language:_charactersMatch(str, onlyCheckIndex)
	local list = type(str) == 'string' and ({str}) or (str)
	if (onlyCheckIndex) then
		return self:_singleForwardCheckMatch(list[onlyCheckIndex], onlyCheckIndex)
	end

	for index, comparisionString in (list) do
		if (self:_singleForwardCheckMatch(comparisionString, index)) then
			return true
		end
	end
end

function language:_jumpForward(n, addendum)
	addendum = addendum or 0

	if (type(n) == 'string') then
		n = #n
	end

	for _ = 1, n + addendum do
		self:_nextCharacter()

		if (self:_isFinished()) then
			break
		end

		if (self:_isLineFinished()) then
			self:_insertNewline()
		end
	end
end

function language:_insertNewline()
	if (self.parameters.newlineFunction) then
		self.parameters.newlineFunction(self, self.tokenizer.rowTokens)
	end

	self.tokenizer.row += 1
	self.tokenizer.column = 0
	table.clear(self.tokenizer.rowTokens)
end

function language:_appendToken()
	self.tokenizer.token[#self.tokenizer.token + 1] = self:_getCharacter()
	self:_nextCharacter()
end

function language:_getToken()
	return self.tokenizer.token
end

function language:_pushToken(newToken)
	self.tokenizer.tokens[#self.tokenizer.tokens + 1] = newToken
	self.tokenizer.rowTokens[#self.tokenizer.rowTokens + 1] = newToken

	table.clear(self.tokenizer.token)
end

function language:_parseSingleToken(token, params)
	local concatenatedToken = table.concat(token)
	if (params.number) then
		concatenatedToken = tonumber(concatenatedToken)
	end
	return concatenatedToken
end

function language:_finishToken(params, custom)
	params = params or {}

	local parsedToken = custom or self:_parseSingleToken(self:_getToken(), params)
	self:_pushToken({
		value = parsedToken,
		keyword = self.keywords[parsedToken],
		params = params,

		row = self.tokenizer.row,
		column = self.tokenizer.column
	})
end

function language:_printNearbyCharacters(n)
	warn('nearby', string.sub(
		self.tokenizer.targetString,
		self.tokenizer.index - n,
		self.tokenizer.index + n
		))
end

function language:_jumpByFeed(v, addendum)
	local symbolFeed = self.tokenizer.symbolFeed
	if (type(v) == 'string') then
		self:_jumpForward(v, addendum)
	else
		self:_jumpForward(v[symbolFeed], addendum)
	end
	return symbolFeed
end

function language:_isSingleCommentSymbol()
	return self.parameters.singleComment and
		self:_charactersMatch(self.parameters.singleComment)
end

function language:_isSingleStringSymbol()
	return self.parameters.singleString and
		self:_charactersMatch(self.parameters.singleString)
end

function language:_isMultiStringSymbolStart()
	return self.parameters.multiString and
		self:_charactersMatch(self.parameters.multiString)
end

function language:_isMultiStringSymbolEnd(symbolFeed)
	return if (self.parameters.multiStringEnd) then
		(self:_charactersMatch(self.parameters.multiStringEnd, symbolFeed)) else
		(self:_charactersMatch(self.parameters.multiString, symbolFeed))
end

function language:_isMultiCommentSymbolStart()
	return self.parameters.multiComment and
		self:_charactersMatch(self.parameters.multiComment)
end

function language:_isMultiCommentSymbolEnd(symbolFeed)
	return if (self.parameters.multiCommentEnd) then
		(self:_charactersMatch(self.parameters.multiCommentEnd, symbolFeed)) else
		(self:_charactersMatch(self.parameters.multiComment, symbolFeed))
end

function language:_hasProximityKeyword(accepting, list)
	for _, a in ipairs(accepting) do
		for _, v in (list) do
			if (v.keyword == self.keywords[a]) then
				return true
			end
		end
	end
end

function language:_collectNumber()
	repeat
		self:_appendToken()
	until (
		(self:_isLineFinished()) or
			(not isNumeric(self:_getCharacter()))
	)

	self:_finishToken({number=true})
end

function language:_collectWord()
	repeat
		self:_appendToken()
	until (
		(self:_isLineFinished()) or
			(not isCharacter(self:_getCharacter()))
	)

	self:_finishToken({alphabetical=true})
end

function language:_collectSingleString()
	local symbolFeed = self:_jumpByFeed(self.parameters.singleString)

	while (
		not self:_isLineFinished() and
			not self:_isSingleStringSymbol()
		) do
		self:_appendToken()
	end

	self:_finishToken({string=true})
end

function language:_collectMultiString()
	local symbolFeed = self:_jumpByFeed(self.parameters.multiString)

	while (
		not self:_isFinished() and
			not self:_isMultiStringSymbolEnd(symbolFeed)
		) do
		self:_appendToken()
	end

	self:_finishToken({string=true})
end

function language:Tokenize(targetString)
	self:ResetTokenizer()

	self.tokenizer.targetIndex = #targetString
	self.tokenizer.targetString = targetString

	while (not self:_isExactFinished()) do
		local character = self:_nextCharacter()
		if ((not self.parameters.noComments) and self:_isMultiCommentSymbolStart()) then
			local symbolFeed = self.tokenizer.symbolFeed
			repeat
				self:_nextCharacter()
			until (
				self:_isFinished() or
					self:_isMultiCommentSymbolEnd(symbolFeed)
			)
		elseif ((not self.parameters.noComments) and self:_isSingleCommentSymbol()) then
			-- comment
			repeat
				self:_nextCharacter()
			until (self:_isLineFinished())

		elseif ((not self.parameters.noStrings) and self:_isMultiStringSymbolStart()) then
			-- get a string

			self:_collectMultiString()

		elseif ((not self.parameters.noStrings) and self:_isSingleStringSymbol()) then
			-- get a string

			self:_collectSingleString()

		elseif ((not self.parameters.noNumbers) and isNumeric(character)) then
			-- build a number into token

			self:_collectNumber()
		elseif (not self.parameters.noWords) and (isAlphabetical(character)) then
			-- build a word into token

			self:_collectWord()
		end

		if (self:_isNewline()) then
			self:_insertNewline()
		end
	end

	local returnTokens = table.clone(self.tokenizer.tokens)
	self:ResetTokenizer()

	return returnTokens
end

function language:GetValueArray(tokens)
	local values = {}
	for _, token in (tokens) do
		table.insert(values, token.value)
	end
	return values
end



-- parser and compiler
function language:_expect(token)
	local arguments = {token.keyword}
	local expectations = token.keyword.expects

	if (#expectations > 0) then
		local jump = #expectations
		for k = 1, jump do
			local retrieved = self:_tokenByIndex(self:_getTokenIndex() + k)
			if (not retrieved) then
				error(`missing arguments for keyword: {token.value}`)
			end

			local shouldNaturallyThrow = (not retrieved.params[expectations[k]])
			local altered, throw;

			if (expectations[k] ~= 'any') then
				if (type(expectations[k]) == 'function') then
					altered, throw = expectations[k](retrieved)
				else
					altered = retrieved.value
					throw = shouldNaturallyThrow and ('invalid type') or (nil)
				end
			end

			if (throw) then
				error(`error when parsing: {throw or 'invalid'} @ {retrieved.row}:{retrieved.column}`)
			end

			table.insert(arguments, altered or retrieved.value)
		end
	end

	return arguments
end

function language:_getTokenIndex()
	return self.parser.tokenIndex
end

function language:_tokenByIndex(k)
	return self.parser.targetTokens[k] or false
end

function language:_isParserDone()
	return self:_getTokenIndex() < self.parser.totalTokens
end

function language:_nextToken()
	self.parser.tokenIndex += 1
	self.parser.token = self.parser.targetTokens[self.parser.tokenIndex]

	return self.parser.token
end

function language:ParseAndCompile(tokens)
	self.parser.targetTokens = tokens
	self.parser.tokenIndex = 0
	self.parser.totalTokens = #tokens

	local compilation = {}
	while (self:_isParserDone()) do
		local token = self:_nextToken()
		local keyword = token.keyword

		if (keyword) then
			--print('IDENTIFIER FOUND WITH KEYWORD', token.value)
			table.insert(compilation, self:_expect(token))
		end
	end

	return compilation
end

-- interpreter
function language:Interpret(bytecode, operation)
	for _, code in (bytecode) do
		operation(code)
	end
end

return language