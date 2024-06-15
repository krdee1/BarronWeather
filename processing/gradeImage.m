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
## @deftypefn {} {@var{grade} =} gradeImage (@var{I})
##
## @seealso{}
## @end deftypefn

## Author: Kevin Dee <kdee@Laertes>
## Created: 2024-06-05

function grade = gradeImage (I)

% Make sure the image is grayscale
if length(size(squeeze(I))) == 3
    I = rgb2gray(I);
end

% Compute image clutter
c = std2(I);

% Compute image entropy
e = entropy(I);

% Grade
grade = [c, e];

endfunction
