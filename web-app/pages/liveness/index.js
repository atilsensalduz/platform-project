// health check URL
function liveness() {
}

// This gets called on every request
export async function getServerSideProps(context) {
  context.res.end('up');
  return { props: { } }
}

export default liveness;

