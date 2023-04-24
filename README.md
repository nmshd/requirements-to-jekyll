# Automatic creation of requirements based on excel table

The use cases and scenarios are listed in an Excel table. This list is extracted and a document page is created for each entry with the metadata entered in the table.

A detailed description for the application can be added.

## Installation
Download the source code and the generate file for the appropriate operating system from the releases.

## Reading data from the excel table

1. For each Page: save the pages to be exported as a .csv file with ";" as a delimiter.

2. Copy the file to the root directory, with the name of the request. e.g.: use-cases.csv

3. run generate with the command for the requirement. e.g.: 

```
./generate use-cases
```

In the appropriate folder ( e.g.: use-cases-gernerated) the jekyll files are created with Front Matter with the metadata

## Add description of the requirements 

The description of the requirements must be written in markdown and located in the folder of the corresponding requirement (e.g.: use-cases).

There is a template in the folder that you can use as a guide.

```htm
<!-- A general description of the requirement can be given here. -->
Lorem ipsum dolor sit amet consectetur adipisicing elit. Perferendis voluptas deserunt alias accusantium rem? Quaerat, temporibus alias fuga rerum unde dolor blanditiis quia incidunt modi rem, sequi, esse aut accusamus.

<!-- This include inserts the table with the metadata  -->
{% include properties_list.html %}

<!-- here is the description in detail  -->
Lorem ipsum dolor sit amet consectetur adipisicing elit. Unde nihil sequi ipsam blanditiis optio nulla quidem tempore sapiente nam, molestiae et voluptas ab harum quo incidunt reiciendis dolorum sed eligendi quos in itaque vel facilis. Rerum quia asperiores porro, odit laborum error voluptates repellat repellendus doloribus minima voluptate debitis libero nemo sit, dolorem consequatur expedita architecto! Molestiae, quae maxime ut iste ratione veniam velit asperiores. Earum corrupti architecto molestiae necessitatibus ullam modi beatae optio distinctio et labore, consectetur, repudiandae alias recusandae quas delectus placeat error laudantium quos, autem non nemo cum. Obcaecati iure maiores quas temporibus assumenda, qui veritatis necessitatibus.

<!-- detailed information about integration and development can be found in this chapter  -->
# Developer Corner

<!-- How to import a graphic stored in the include folder -->
<details >
  <summary>Flowchart</summary>
  <div>{% include diagrams/Enmeshed_Scenarios.svg %}</div>
</details>

```

1. Copy the template or create a new file, with the same name as the name in the e.g.: use-cases-generated folder

2. Customize the file as desired. It is important not to forget the include table for the metadata. 

3. run ./generate with the command for the requirement. e.g.:

```
./generate use-cases
```

## Use the default template

In the folder for the requirement is a default.md file. This can be used if there is no description for the respective requirement. In the Excel table, the value default must now be entered in the published column. 

! Adding a specific description overwrites the "default" flag