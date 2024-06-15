## Copyright (C) 2024 Kevin Dee
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{I} =} cleanImage (@var{I}})
##
## @seealso{}
## @end deftypefn

## Author: Kevin Dee <kdee@Laertes>
## Created: 2024-06-08

function I = cleanImage (I, AVHRR_TYPE, dbug)

% Make sure the image is grayscale
if length(size(squeeze(I))) == 3
    I = rgb2gray(I);
end

% Test if the last line is all constant, and remove it if it is
if size(unique(I(end, :)))(2) == 1
	I = I(1:end-1, :);
end

% Clutter threshhold at which a line will be considered noisy
% High and low threshholds for implementing a Schmitt trigger (Hysteresis)

% Choose threshholds based on the AVHRR imager waveband
switch AVHRR_TYPE
	case "A"
		clutterLimitHi = 12500;
		clutterLimitLo = 10750;
		meanThreshhold = 2000; % Above --> noisy image (x10 difference)
		stdThreshhold = 3000; % Above --> noisy image (x10 difference)
		varThreshhold = 1e7; % Above --> noisy image (x100 difference)
	case "B"
		clutterLimitHi =  9500;
		clutterLimitLo =  9000;
		meanThreshhold = 2000; % Above --> noisy image (x10 difference)
		stdThreshhold = 3000; % Above --> noisy image (x10 difference)
		varThreshhold = 1e7; % Above --> noisy image (x100 difference)
end

% Image size
sz = size(I);

% Initialize array to contain pixel to pixel differences along each row in the image
diffs = zeros(sz(1), sz(2) - 1);

% Initialize booleans to record how each row compares to noise threshholds in various metrics
meanQuality = zeros(sz(1), 1); % true - Good image, false - noisy image
stdQuality = meanQuality;
varQuality = meanQuality;

% Iterate over the rows of the image
for i = 1:sz(1)
	% Compute pixel to pixel differences in the ith row
	diffs(i, :) = diff(I(i, :));

	% Assess row mean against threshhold
	if mean(diffs(i, :)) > meanThreshhold
		meanQuality(i) = 1;
	end
	% Assess row std against threshhold
	if std(diffs(i, :)) > stdThreshhold
		stdQuality(i) = 1;
	end
	% Assess row var against threshhold
	if var(diffs(i, :)) > varThreshhold
		varQuality(i) = 1;
	end
end

% Sum quality checks here to determine overall row quality values
% TODO: Add scaling factors based on anecdotally observed difference levels in these metrics?
quality = meanQuality + stdQuality + varQuality;

% Normalize quality
quality = quality/max(quality);

% check if the image is all noise
if min(quality) == 1
	I = NaN;
	return;
end

% Mark regions of the image based on row quality
% Construct additional known rows to simplify the creation of regions
nrows = 50;
I = [zeros(nrows, sz(2)); I; zeros(nrows, sz(2));];
quality = [ones(nrows, 1); quality; ones(nrows, 1);]; % Creates known rows of maximum noise at the beginning and end of the image

% Round quality values down, only accept regions that all checks consider good
quality = floor(quality);

% Find changes in quality
diffQ = diff(quality);
dQidx = find(diffQ);

% Sign noise changes according to increase or decrease in noise
s = -1;
for i = 1:length(dQidx)
	dQidx(i) = s * dQidx(i);
	s = -s;
end

% Indices of region bounds, signed with noise going high or low
regionBounds = [1, dQidx', -length(quality)]; % The first row is known to begin a noisy region, and the last row is known to end a noisy region

% Remove the last region of the image, which must be noisy by construction
I = I(1:abs(regionBounds(end - 1)), :);
regionBounds = regionBounds(1:end - 1);

% Remove the first region of the image, which must be noisy by construction
I = I(abs(regionBounds(2)):end, :);
regionBounds = regionBounds(2:end);
regionBounds = regionBounds + sign(-regionBounds) * (abs(regionBounds(1)));
regionBounds(1) = 1; % zero index fix





##% Number of rows to consider in rolling clutter calcuation
##nroll = 10; % Must be even
##
##% Make sure the image has an even number of rows, repeating the last row if necessary
##if mod(size(I)(1), 2)
##	I = [I; I(end, :)];
##end
##
##% Repeat the last nroll rows to allow clutter calculation
##I = [I; I(end - (nroll):end, :)];
##
##% Initialize array of clutter values
##clutter = zeros(1, size(I)(1)-nroll);
##
##% Compute array of forward rolling clutter values from the top of the image down
##for ii = 1:(size(I)(1) - nroll)
##	clutter(ii) = std2(I(ii:ii+10, :));
##end
##
##% Flag indices above the clutter threshhold
##% Schmitt trigger
##clutterBool = false(1, length(clutter)-nroll+1);
##for ii = 1:(length(clutter)-nroll)
##	if clutter(ii) < clutterLimitLo && clutter(ii) < clutterLimitHi
##		continue % Definitely low
##	elseif clutter(ii) > clutterLimitLo && clutter(ii) > clutterLimitHi
##		clutterBool(ii) = true; % Definitely high
##	elseif clutter(ii) < clutterLimitHi && clutter(ii) > clutterLimitLo
##		if ii == 1
##			% assume high
##			clutterBool(ii) = true;
##		elseif clutterBool(ii - 1)
##			clutterBool(ii) = true; % was high, between threshholds, stays high
##		end % was low, between threshholds, stays low (initialized value)
##	end
##end
##
##boundaries = [1];
##
##cluttered = [-1, find(clutterBool), length(clutterBool)];
##clean = [-1, find(~clutterBool), length(clutterBool)];
##
##boundaries = sort([boundaries, cluttered(find(diff(cluttered) > 1) + 1), clean(find(diff(clean) > 1) + 1), length(clutterBool)]);
##
##if boundaries(end) == boundaries(end - 1) + 1
##	boundaries = boundaries(1:end - 1);
##end
##
##boundaries = boundaries(2:end-1);
##
##if mod(length(boundaries), 2)
##	boundaries = [boundaries(1:end-1), boundaries(end) - 1, boundaries(end)];
##end
##
##% Apply signs to these indices to signify rising/falling through the clutter threshhold
##% Negative for falling, positive for rising (obviously?)
##% Check if the first block is consisdered cluttered or clean by looking at which clutterBool is more common in the block
##% Given the first block as rising/falling, the others will always flip the state
##signMultiplier = repmat([-1, 1], 1, length(boundaries)/2);
##if sum(clutterBool(boundaries(1):boundaries(2))) >= length(boundaries(1):boundaries(2))/2
##	signMultiplier = -signMultiplier;
##end
##boundaries = signMultiplier.*boundaries;
##
##I = I(1:end-nroll, :);
##
##% Now begin pruning cluttered blocks on the top and bottom of the image
##if sign(boundaries(1)) + 1
##	% Remove first block
##	I = I(abs(boundaries(2)):end, :);
##	% Adjust boundaries
##	boundaries = boundaries(3:end) + repmat([-1, 1], 1, length(boundaries(3:end))/2)*abs(boundaries(2)) + 1;
##end
##
##if isempty(boundaries)
##	return
##end
##
##if sign(boundaries(end - 1)) + 1
##	% Remove last block
##	I = I(1:abs(boundaries(end - 1)), :);
##	boundaries = boundaries(1:end-2);
##end
##
##if isempty(boundaries)
##	return
##end




##for ii = 1:length(clutterBool)
##
##end
##
##
##
##
##
##
##
##
##
##
##
##
##
##
##
##
##
##
##
##keyboard
##
##
##
##
##% Remove the artificially repeated last nroll rows from the image
##
##% Find rows from indices, find rows where the clutter flag changes
##clutterRows = find(clutterBool); % Indices of rows with clutter
##dcr = diff(clutterRows);
##dcr = [dcr, 9999];
##clutterSwitch = find(dcr > 1); % Indices of rows with significant changes in clutter
##
##clutterSwitchRows = clutterRows(clutterSwitch(1:end));
##
##% Stop here if not enough noisy lines were found (unlikely)
##if ~any(clutterBool)
##	return
##end
##
##
##if clutterSwitchRows(end) ~= length(clutterBool)-nroll-1
##	clutterSwitchRows = [clutterSwitchRows, length(clutterBool)-nroll-1];
##end
##
##startIndex = [];
##for ii = 2:length(clutterSwitchRows)
##	startIndex = [startIndex, length(find(dcr > 1)(ii - 1):find(dcr > 1)(ii))];
##end
##
##for ii = 2:length(clutterSwitchRows)
##	clutterSwitchRows = [clutterSwitchRows(1:end), clutterSwitchRows(ii) - startIndex(ii - 1)];
##end
##clutterSwitchRows = sort([0, clutterSwitchRows]);
##
##% Check for odd num of clutterSwitchRows
##if mod(length(clutterSwitchRows), 2)
##	error("Odd number of clutter switch rows found");
##end
##clutterSwitchRows = clutterSwitchRows + repmat([1, 0], 1, length(clutterSwitchRows)/2);
##
##% Make sure the first and last rows are included here
##if clutterSwitchRows(1) ~= 1
##	clutterSwitchRows = [1, clutterSwitchRows];
##end
##
##% Apply signs to these indices to signify rising/falling through the clutter threshhold
##% Negative for falling, positive for rising (obviously?)
##% Check if the first block is consisdered cluttered or clean by looking at which clutterBool is more common in the block
##% Given the first block as rising/falling, the others will always flip the state
##signMultiplier = repmat([-1, 1], 1, length(clutterSwitchRows)/2);
##if sum(clutterBool(clutterSwitchRows(1):clutterSwitchRows(2))) >= length(clutterSwitchRows(1):clutterSwitchRows(2))/2
##	signMultiplier = -signMultiplier;
##end
##clutterSwitchRows = signMultiplier.*clutterSwitchRows;
##
##
##% Now begin pruning cluttered blocks on the top and bottom of the image
##if sign(clutterSwitchRows(1)) == -1
##	% Remove first block
##	I = I(clutterSwitchRows(2):end, :);
##end
##
##if sign(clutterSwitchRows(end)) == -1
##	% Remove last block
##	I = I(1:clutterSwitchRows(end - 1), :);
##end
##
##% Next, if cluttered blocks one layer deep are covered by clean blocks with fewer rows, remove both blocks
##
##
##
##
##
##
##
##
##
##
##
##
##
####keyboard
####
####
####
####
####
####% Entropy threshhold at which a line will be considered noisy
####entropyLimit = 7.25;
####% Adder to entropy limit for rolling comparisons
####rollingAdder = 0.3;
####rollingEntropyLimit = entropyLimit + rollingAdder;
####
####% Trim lines of static from the top down
####unclean = true;
####while unclean
####	% Make sure the image is substantial enough to continue processing on
####	if size(I)(1) < 300
####		I = NaN;
####		return
####	end
####	% Test if the first row's noise level is excessive
####	if entropy(I(1, :)) > entropyLimit
####		I = I(2:end, :); % Remove first line (noise)
####	else
####		% Check the entropy of the next 10 lines to ensure this unclean line is not an outlier
####		if entropy(I(1:10, :)) > rollingEntropyLimit
####			I = I(2:end, :); % Remove first line (noise)
####		else
####			unclean = false;
####		end
####	end
####end
####
####% Trim lines of static from the bottom up
####unclean = true;
####while unclean
####	% Make sure the image is substantial enough to continue processing on
####	if size(I)(1) < 300
####		I = NaN;
####		return
####	end
####	% Test if the last row's noise level is excessive
####	if entropy(I(end, :)) > entropyLimit
####		I = I(1:end-1, :); % Remove last line (noise)
####	else
####		% Check the entropy of the next 10 lines to ensure this unclean line is not an outlier
####		if entropy(I(end-9:end, :)) > rollingEntropyLimit
####			I = I(2:end, :); % Remove first line (noise)
####		else
####			unclean = false;
####		end
####	end
####end


endfunction
