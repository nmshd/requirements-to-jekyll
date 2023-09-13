module main

import encoding.csv
import os
import cli

struct TypeObject {
	id      string
	title   string
	my_type string
}

struct Navbar {
mut:
	navbar  []string
	keylist []string
}

fn main() {
	mut app := cli.Command{
		name: 'md_generator'
		description: 'this script combines the lines from a csv file with the markdown files in the corresponding folder and additionally creates a header for jekyll'
		required_args: 1
		commands: [
			cli.Command{
				name: 'scenarios'
				execute: scenarios_func
				description: 'Creates scenarios from the scenarios.csv and the scenarios folder'
			},
			cli.Command{
				name: 'use-cases'
				execute: use_cases_func
				description: 'Creates use-cases from the use-cases.csv and the use-cases folder'
			},
		]
	}
	app.setup()
	app.parse(os.args)
}

fn scenarios_func(app cli.Command) ! {
	filename := 'scenarios.csv'

	filedata := os.read_file(filename) or {
		panic('error reading file ${filename}')
		return
	}
	mut parser := csv.new_reader(filedata, csv.ReaderConfig{ delimiter: `;` })
	mut header := parser.read()!
	mut j := 0
	name_list := mapper()
	mut description_counter := 0
	contingency_table := create_contingency_table()
	column_title := get_columnn_id_by_title('title', header)
	column_require := get_columnn_id_by_title('require', header)
	column_published := get_columnn_id_by_title('published', header)
	column_id := get_columnn_id_by_title('id', header)
	column_nbp_scenario := get_columnn_id_by_title('nbp_scenario', header)
	column_jira := get_columnn_id_by_title('link to jira', header)
	column_redirect := get_columnn_id_by_title('redirect_from', header)
	column_category := get_columnn_id_by_title('category', header)
	column_component := get_columnn_id_by_title('component', header)
	column_link := get_columnn_id_by_title('link', header)

	// template_file := os.read_file('_requirements/_docs_scenarios/_template.md')!
	mut navbar_use := Navbar{}
	mut navbar_integrate := Navbar{}
	mut navbar_operate := Navbar{}
	for {
		row := parser.read() or { break }

		j = find_title_in_array(name_list, row[column_title])
		mut text := '---\n'
		//mut optimized_filename := row[column_link].to_lower().replace_each([' ','_','<','','>','',':',' ','/','-'])
		mut optimized_filename := row[column_link].to_lower()
		text += 'permalink: ' + row[column_link] + '\n'
		if row[column_published] != '' {
			text += 'redirect_from: ' + row[column_redirect] + '\n'
		}
		if row[column_published].contains('true') {
			text += 'published: true\n'
			description_counter++
		} else {
			text += 'published: false\n'
		}

		match row[column_component] {
			'App' {
				text += 'sidebar:
  - title: "Use Enmeshed"
    nav: "docs_use"\n'
			}
			'Runtime' {
				text += 'sidebar:
  - title: "Integrate Enmeshed"
    nav: "docs_integrate"\n'
			}
			'Connector' {
				text += 'sidebar:
  - title: "Operate Enmeshed"
    nav: "docs_operate"\n'
			}
			else {
				println('column not found: ' + row.str())
			}
		}

		text += 'title: "' +
			row[column_title].replace_each(['<', '', '>', '', ':', '', '’', "'"]) + '"\n'
		text += 'type: scenario\n'
		text += 'toc: true\n'
		text += 'properties:\n'
		for i, cell in row {
			if i != column_title && i != column_require && i != column_nbp_scenario
				&& i != column_jira && i != column_redirect {
				if cell != '' {
					text += '  - ' + header[i].to_lower() + ': ' +
						cell.replace_each(['<', '', '>', '', ':', '', '\n', ' ', '`', "'"]) + '\n'
				} else {
					text += '  - ' + header[i].to_lower() + ':\n'
				}
			}
		}
		text += 'require:\n'
		for key, values in contingency_table[j] {
			if values {
				text += '  - ' + name_list[key].my_type + '-' +
					name_list[key].id.to_lower().replace_each([' ', '_', '<', '', '>', '', ':', ' ', '/', '']) +
					'\n'
			}
		}
		text += 'required_by:\n'
		for key, value in contingency_table {
			if value[j] {
				text += '  - ' + name_list[key].my_type + '-' +
					name_list[key].id.to_lower().replace_each([' ', '_', '<', '', '>', '', ':', ' ', '/', '']) +
					'\n'
			}
		}
		text += '---\n'
		text += '\n{% include scenarios/' + optimized_filename + '.md %}\n'
		mut tmp_filename := './_requirements/_docs_scenarios/' + optimized_filename + '.md'
						println('ERRROROROROROR' + tmp_filename)

		mut f := os.create(tmp_filename)!

		f.write_string(text) or { panic('error writing file ${filename}') }
		f.close()
		j++

		if row[column_published] == 'true' {
			match row[column_component] {
				'App' {
					add_to_navbar(row[column_category], row[column_title], '/scenario-' +
						optimized_filename, mut navbar_use)
				}
				'Runtime' {
					add_to_navbar(row[column_category], row[column_title], '/scenario-' +
						optimized_filename, mut navbar_integrate)
				}
				'Connector' {
					add_to_navbar(row[column_category], row[column_title], '/scenario-' +
						optimized_filename, mut navbar_operate)
				}
				else {
					println('column not found: ' + row.str())
				}
			}
		}
	}
	sort_array(mut navbar_use)
	sort_array(mut navbar_integrate)
	sort_array(mut navbar_operate)
	println('scenarios: successfully created ${j} files and used ${description_counter} descriptions')
	mut navbar_text := ''
	navbar_text += 'docs_use:\n'
	for row in navbar_use.navbar {
		navbar_text += row
	}
	navbar_text += '\ndocs_integrate:\n'
	for row in navbar_integrate.navbar {
		navbar_text += row
	}
	navbar_text += '\ndocs_operate:\n'
	for row in navbar_operate.navbar {
		navbar_text += row
	}

	mut navbar_filename := './navbar.md'
	mut f := os.create(navbar_filename)!
	f.write_string(navbar_text) or { panic('error writing file ${filename}') }
	f.close()
}

fn use_cases_func(app cli.Command) ! {
	filename := 'use-cases.csv'

	filedata := os.read_file(filename) or {
		panic('error reading file ${filename}')
		return
	}
	mut parser := csv.new_reader(filedata, csv.ReaderConfig{ delimiter: `;` })
	mut header := parser.read()!
	mut j := 0
	mut description_counter := 0
	contingency_table := create_contingency_table()
	column_title := get_columnn_id_by_title('title', header)
	column_require := get_columnn_id_by_title('require', header)
	column_published := get_columnn_id_by_title('published', header)
	column_id := get_columnn_id_by_title('id', header)
	column_jira := get_columnn_id_by_title('link to jira', header)
	// template_file := os.read_file('_requirements/_docs_use-cases/_template.md')!

	for {
		row := parser.read() or { break }
		mut text := '---\n'
		mut optimized_filename := row[column_id].to_lower()
		text += 'permalink: /use-case-' + optimized_filename + '\n'
		if os.exists('_requirements/_docs_use-cases/use-case-' + optimized_filename + '.md')
			|| row[column_published].contains('default') {
			text += 'published: true\n'
			description_counter++
		} else {
			text += 'published: false\n'
		}

		text += 'title: "' +
			row[column_title].replace_each(['<', '', '>', '', ':', '', '’', "'"]) + '"\n'
		text += 'type: use-case\n'
		text += 'toc: true\n'
		text += 'properties:\n'
		for i, cell in row {
			if i != column_title && i != column_require && i != column_jira {
				if cell != '' {
					text += '  - ' + header[i].to_lower() + ': ' +
						cell.replace_each(['<', '', '>', '', ':', '', '\n', ' ', '`', "'"]) + '\n'
				} else {
					text += '  - ' + header[i].to_lower() + ':\n'
				}
			}
		}
		text += 'require:\n'
		for key, value in contingency_table[j] {
			if value {
				name_list := mapper()
				text += '  - ' + name_list[key].my_type + '-' +
					name_list[key].id.to_lower().replace_each([' ', '_', '<', '', '>', '', ':', ' ', '/', '']) +
					'\n'
			}
		}
		text += 'required_by:\n'
		for key, value in contingency_table {
			if value[j] {
				name_list := mapper()
				text += '  - ' + name_list[key].my_type + '-' +
					name_list[key].id.to_lower().replace_each([' ', '_', '<', '', '>', '', ':', ' ', '/', '']) +
					'\n'
			}
		}
		text += '---\n'
		text += '\n{% include use-cases/use-case-' + optimized_filename + '.md %}\n'
		mut tmp_filename := './_requirements/_docs_use-cases/use-case-' + optimized_filename + '.md'
		mut f := os.create(tmp_filename)!
		f.write_string(text) or { panic('error writing file ${filename}') }
		f.close()
		j++
	}
	println('successfully created ${j} files and used ${description_counter} descriptions')
}

/**
 * Retrieves the index of the column within a header array that matches a specified title.
 *
 * @param {string} title_searched - The title of the column to search for.
 * @param {string[]} header - An array of strings representing the titles of columns.
 * @returns {int} The index or ID of the column with the specified title, or -1 if not found.
*/
fn get_columnn_id_by_title(title_searched string, header []string) int {
	for key, title_comparable in header {
		if compare_strings(title_comparable.to_lower(), title_searched.to_lower()) == 0 {
			return key
		}
	}
	println('cant get id by title: ${title_searched}')
	return -1
}

/**
 * Searches an array of strings for the first occurrence of a specified value and returns its index.
 *
 * @param {string[]} array - The array of strings to search.
 * @param {string} value - The value to search for in the array.
 * @returns {int} The index of the first occurrence of the specified value in the array, or -1 if not found.
*/
fn find_id_in_array(array []TypeObject, value string) int {
	for key, compare_value in array {
		if compare_strings(compare_value.id.to_lower(), value.to_lower()) == 0 {
			return key
		}
	}
	println('${value} not found')
	return -1
}

/**
 * Searches an array of strings for the first occurrence of a specified value and returns its index.
 *
 * @param {TypeObject[]} array - The array of strings to search.
 * @param {string} value - The value to search for in the array.
 * @returns {int} The index of the first occurrence of the specified value in the array, or -1 if not found.
*/
fn find_title_in_array(array []TypeObject, value string) int {
	for key, compare_value in array {
		if compare_strings(compare_value.title.to_lower(), value.to_lower()) == 0 {
			return key
		}
	}
	return -1
}

/**
 * Extracts the values of the 'id' column from a CSV file and returns them as a string array.
 *
 * @param {string} filename - The name of the CSV file to read.
 * @returns {string[]} An array of strings representing the values of the 'id' column, or [] if not found or error.
*/
fn mapper() []TypeObject {
	mut filename := 'use-cases.csv'
	mut filedata := os.read_file(filename) or {
		panic('error reading file ${filename}')
		return []
	}
	mut parser := csv.new_reader(filedata, csv.ReaderConfig{ delimiter: `;` })
	mut header := parser.read() or { [] }
	mut id := get_columnn_id_by_title('id', header)
	mut title := get_columnn_id_by_title('title', header)
	mut list := []TypeObject{}
	for {
		entry := parser.read() or { break }
		if entry[id] == '' || entry[title] == '' {
			panic('missing id in ${entry}')
		}
		obj := TypeObject{
			id: entry[id]
			title: entry[title]
			my_type: '/use-case'
		}
		list << obj
	}
	filename = 'scenarios.csv'
	filedata = os.read_file(filename) or {
		panic('error reading file ${filename}')
		return []
	}
	parser = csv.new_reader(filedata, csv.ReaderConfig{ delimiter: `;` })
	header = parser.read() or { [] }
	id = get_columnn_id_by_title('id', header)
	title = get_columnn_id_by_title('title', header)
	for {
		entry := parser.read() or { break }
		obj := TypeObject{
			id: entry[id]
			title: entry[title]
			my_type: '/scenario'
		}
		list << obj
	}
	return list
}

/**
 * Reads a file and generates a contingency table based on the "require" column in the CSV file.
 *
 * @param {string} filename - The name of the CSV file to read.
 * @returns {boolean[][]} A 2D boolean array representing the contingency table, where each row represents a requirement and each column represents a requirement that it depends on. The value at each cell (i, j) is true if requirement i depends on requirement j, and false otherwise.
*/
fn create_contingency_table() [][]bool {
	mut filename := 'use-cases.csv'
	id_list := mapper()
	mut filedata := os.read_file(filename) or {
		panic('error reading file ${filename}')
		return []
	}
	mut parser := csv.new_reader(filedata, csv.ReaderConfig{ delimiter: `;` })
	mut header := parser.read() or { [] }

	mut require_list := [][]bool{}
	for require in id_list {
		mut required_by_list := []bool{}
		for required_by in id_list {
			required_by_list << false
		}
		require_list << required_by_list
	}
	mut require_key := 0
	for {
		mut text := parser.read() or { break }
		requirements := (text[get_columnn_id_by_title('require', header)].replace(' ',
			'').split(','))
		for requierd_by in requirements {
			if requierd_by != '' {
				required_by_key := find_id_in_array(id_list, requierd_by)
				require_list[require_key][required_by_key] = true
			}
		}
		require_key++
	}
	filename = 'scenarios.csv'
	filedata = os.read_file(filename) or {
		panic('error reading file ${filename}')
		return []
	}
	parser = csv.new_reader(filedata, csv.ReaderConfig{ delimiter: `;` })
	header = parser.read() or { [] }
	for {
		mut text := parser.read() or { break }
		requirements := (text[get_columnn_id_by_title('require', header)].replace(' ',
			'').split(','))
		for requierd_by in requirements {
			if requierd_by != '' {
				required_by_key := find_id_in_array(id_list, requierd_by)
				require_list[require_key][required_by_key] = true
			}
		}
		require_key++
	}
	return require_list
}

fn add_to_navbar(category string, title string, url string, mut navbar Navbar) int {
	key := category_to_keylist(category, mut navbar)
	navbar.navbar[key] += '      - title: "' + title + '"\n        url: ' + url + '\n'
	return 1
}

fn category_to_keylist(category string, mut navbar Navbar) int {
	for key, compare_value in navbar.keylist {
		if compare_strings(compare_value.to_lower(), category.to_lower()) == 0 {
			return key
		}
	}
	navbar.keylist << category
	navbar.navbar << '  - title: ' + category + '\n    children:\n'
	return navbar.keylist.len - 1
}

fn sort_array(mut navbar Navbar) int {
	navbar.keylist.sort()
	navbar.navbar.sort()
	return 1
}
