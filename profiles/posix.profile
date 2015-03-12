/* posix.profile
 *
 * Copyright (C) 2014 Johan Mattsson
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * As a special exception, if you use inline functions from this file, this
 * file does not by itself cause the resulting executable to be covered by
 * the GNU Lesser General Public License.
 *
 * Author:
 *      Johan Mattsson <johan.mattsson.m@gmail.com>
 */

definition allocate (type, variable, elements)
	variable = (type*) malloc (elements * sizeof (type));
	assert (variable != NULL);
	memset (variable, 0, elements * sizeof (type));

definition free (variable)
	if (variable != NULL) {
		free (variable);
	}

definition slice_new (type, variable)
	variable = (type*) malloc (sizeof (type));
	memset (variable, 0, sizeof (type));

definition slice_free (type, variable)
	if (variable != NULL) {
		free (variable);
	}
	
definition log (message)
	printf (message); 
