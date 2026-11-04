float4 gAmbientOcclusionEffect : register(c63);
float4 gDirectionalColour : register(c20);
float4 gDirectionalLight : register(c19);
float4 gLightAmbient0 : register(c33);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 normal : NORMAL;
	float4 texcoord : TEXCOORD;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	r0.x = abs(gDirectionalLight.z);
	r0.x = r0.x * gDirectionalColour.w;
	r0.xyz = r0.xxx * gDirectionalColour.xyz;
	r0.w = 1 / gAmbientOcclusionEffect.y;
	o.texcoord3.xyz = gLightAmbient0.xyz * r0.www + r0.xyz;
	r0.xy = i.texcoord.xy * i.texcoord.xy;
	r0.x = r0.y + r0.x;
	r0.x = rsqrt(r0.x);
	o.texcoord1.xy = r0.xx * i.texcoord.xy;
	r0.yz = i.color.xx * float2(-2, 2) + float2(1, -1);
	r0.yz = r0.yz * i.texcoord.yx;
	o.texcoord1.zw = r0.xx * r0.yz;
	o.texcoord2.w = r0.x;
	r0.xyz = -gViewInverse[3].xyz + i.position.xyz;
	o.texcoord.xyz = -r0.xyz;
	r0 = gWorldViewProj[1] * i.position.y;
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	r0 = r0 + gWorldViewProj[3];
	o.position = r0;
	o.texcoord.w = r0.w;
	o.texcoord3.w = i.color.w;
	o.texcoord2.xyz = i.normal.xyz;

	return o;
}
