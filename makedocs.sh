set -e -o pipefail
kal_project_dir=`pwd`
source_dir=${kal_project_dir}
echo generating documents for ${kal_project_dir}
mkdir -p docs
cd ~
mkdir -p tmp
cd tmp
rm -rf adrdox
git clone https://github.com/adamdruppe/adrdox
cp ${kal_project_dir}/.skeleton.html adrdox/skeleton.html
cd adrdox
make
./doc2 -i ${source_dir}/deimos
mkdir -p ${kal_project_dir}/docs/example
mv generated-docs/* ${kal_project_dir}/docs
./doc2 -i ${source_dir}/examples/parser/source
mv generated-docs/* ${kal_project_dir}/docs/example
cp ${kal_project_dir}/docs/deimos.mrss.html ${kal_project_dir}/docs/index.html
cp ${kal_project_dir}/docs/example/kaleidic.api.mrss.example.html ${kal_project_dir}/docs/example/index.html
cd ${kal_project_dir}
echo succeeded - docs generated
